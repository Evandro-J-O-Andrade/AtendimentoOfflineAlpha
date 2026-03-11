/**
 * ================================================================
 * Login Context Service - Versão Parruda
 * ================================================================
 * 
 * Serviço de contexto de login para o HIS offline-first.
 * Implementa autenticação completa e runtime parrudo:
 * - Perfis, contextos e permissões
 * - Filas e pacientes (FFA) do local
 * - Especialidades médicas
 * - Sessão auditável
 * 
 * Não gera senha sozinho nem chama paciente automático.
 * @version 1.0.0-parrudo
 * ================================================================
 */

const pool = require("../config/database");
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const { SECRET, EXPIRES_IN } = require("../config/jwt");

class LoginContextService {

    /**
     * Realiza o login completo com contexto operacional
     * @param {Object} credentials - Credenciais do usuário
     * @returns {Promise<Object>} Token JWT e contexto completo
     */
    static async login(credentials) {
        const { 
            login, 
            senha, 
            id_sistema,
            id_unidade, 
            id_local_operacional, 
            id_dispositivo,
            ip_acesso, 
            user_agent,
            token_dispositivo 
        } = credentials;

        console.log("LoginContextService.login called:", { login, id_unidade, id_dispositivo });

        let conn;
        try {
            conn = await pool.getConnection();
            await conn.beginTransaction();

            // ==============================
            // PASSO 1: Validação de Identidade
            // ==============================
            const user = await LoginContextService._buscarUsuario(conn, login);
            if (!user) {
                await conn.rollback();
                return { error: "USUARIO_NAO_ENCONTRADO" };
            }

            // ==============================
            // PASSO 2: Validação de Senha
            // ==============================
            const senhaValida = await LoginContextService._validarSenha(senha, user.senha_hash);
            if (!senhaValida) {
                await LoginContextService._registrarFalhaLogin(conn, user.id_usuario);
                await conn.commit();
                return { error: "SENHA_INCORRETA" };
            }

            // ==============================
            // PASSO 3: Validar dispositivo (se fornecido)
            // ==============================
            let dispositivo = null;
            if (id_dispositivo || token_dispositivo) {
                dispositivo = await LoginContextService._validarDispositivo(
                    conn, 
                    id_dispositivo, 
                    token_dispositivo
                );
                if (!dispositivo) {
                    await conn.rollback();
                    return { error: "DISPOSITIVO_INVALIDO" };
                }
            }

            // ==============================
            // PASSO 4: Selecionar contexto operacional
            // ==============================
            const resultadoContexto = await LoginContextService._selecionarContexto(
                conn, 
                user.id_usuario, 
                id_sistema,
                id_unidade, 
                id_local_operacional
            );

            if (!resultadoContexto) {
                await conn.rollback();
                return { error: "USUARIO_SEM_CONTEXTO" };
            }

            // Extrair contexto atual e lista de contextos
            const contexto = resultadoContexto.contextoAtual;
            const listaContextos = resultadoContexto.contextos;

            // ==============================
            // PASSO 5: Criar sessão
            // ==============================
            const sessao = await LoginContextService._criarSessao(
                conn,
                user.id_usuario,
                contexto,
                dispositivo,
                ip_acesso,
                user_agent
            );

            // ==============================
            // PASSO 6: Atualizar contexto do usuário
            // ==============================
            await LoginContextService._atualizarContextoUsuario(
                conn,
                user.id_usuario,
                contexto,
                sessao.id_sessao_usuario
            );

            // ==============================
            // PASSO 7: Buscar runtime parrudo (estrutura completa)
            // ==============================
            const runtimeParrudo = await LoginContextService._buscarRuntimeParrudo(conn, user.id_usuario);
            
            // ==============================
            // PASSO 7b: Atualizar runtime com pacientes nas filas (VERSÃO PARRUDO)
            // ==============================
            const filasPacientes = await LoginContextService._atualizarRuntimeFilasPacientes(
                conn,
                user.id_usuario,
                contexto.id_unidade,
                contexto.id_local_operacional
            );
            
            // Incluir pacientes em cada perfil do runtime
            runtimeParrudo.forEach(perfil => {
                if (perfil.contextos && perfil.contextos.length > 0) {
                    perfil.contextos.forEach(ctx => {
                        // Adicionar pacientes apenas no contexto atual
                        if (ctx.id_unidade === contexto.id_unidade && 
                            ctx.id_local_operacional === contexto.id_local_operacional) {
                            ctx.filasPacientes = filasPacientes;
                        }
                    });
                }
            });
            
            // Buscar permissões do perfil atual
            const permissoes = contexto.id_perfil 
                ? await LoginContextService._buscarPermissoes(conn, contexto.id_perfil)
                : [];

            // ==============================
            // PASSO 8: Buscar dados completos do contexto
            // ==============================
            const dadosContexto = await LoginContextService._buscarDadosContexto(
                conn,
                contexto.id_unidade,
                contexto.id_local_operacional,
                dispositivo
            );

            await conn.commit();

            // ==============================
            // RETORNO: Token JWT com contexto completo
            // ==============================
            // Formatar lista de contextos para o token
            const contextosToken = listaContextos.map(ctx => ({
                id_sistema: ctx.id_sistema ?? 1,
                id_unidade: ctx.id_unidade,
                id_local_operacional: ctx.id_local_operacional,
                id_perfil: ctx.id_perfil,
                perfil: ctx.perfil_nome,
                unidade_nome: ctx.unidade_nome || dadosContexto.unidade?.nome,
                local_nome: ctx.local_nome || dadosContexto.local?.nome,
                local_tipo: ctx.local_tipo
            }));

            const tokenPayload = {
                id_usuario: user.id_usuario,
                login: user.login,
                id_sessao_usuario: sessao.id_sessao_usuario,
                id_sistema: contexto.id_sistema ?? 1,
                id_unidade: contexto.id_unidade,
                id_local_operacional: contexto.id_local_operacional,
                id_perfil: contexto.id_perfil,
                perfil: contexto.perfil_nome,
                id_dispositivo: dispositivo?.id_dispositivo || null,
                tipo_dispositivo: dispositivo?.tipo || null,
                permissoes: permissoes.map(p => p.acao),
                contextos: contextosToken,
                runtime: runtimeParrudo
            };

            const token = jwt.sign(tokenPayload, SECRET, { expiresIn: EXPIRES_IN });

            return {
                token,
                runtime: runtimeParrudo,
                sessao: {
                    id_sessao_usuario: sessao.id_sessao_usuario,
                    token_runtime: sessao.token_runtime,
                    expira_em: sessao.expira_em
                },
                usuario: {
                    id_usuario: user.id_usuario,
                    login: user.login
                },
                contexto: {
                    id_sistema: contexto.id_sistema ?? 1,
                    id_unidade: contexto.id_unidade,
                    unidade_nome: contexto.unidade_nome || dadosContexto.unidade?.nome,
                    id_local_operacional: contexto.id_local_operacional,
                    local_nome: contexto.local_nome || dadosContexto.local?.nome,
                    id_perfil: contexto.id_perfil,
                    perfil: contexto.perfil_nome
                },
                contextos: listaContextos.map(ctx => ({
                    id_sistema: ctx.id_sistema ?? 1,
                    id_unidade: ctx.id_unidade,
                    unidade_nome: ctx.unidade_nome,
                    id_local_operacional: ctx.id_local_operacional,
                    local_nome: ctx.local_nome,
                    local_tipo: ctx.local_tipo,
                    id_perfil: ctx.id_perfil,
                    perfil: ctx.perfil_nome
                })),
                dispositivo: dispositivo ? {
                    id_dispositivo: dispositivo.id_dispositivo,
                    nome: dispositivo.nome,
                    tipo: dispositivo.tipo
                } : null,
                permissoes
            };

        } catch (err) {
            console.error("LoginContextService error:", err);
            if (conn) await conn.rollback();
            throw err;
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Seleciona um contexto específico (quando há múltiplas escolhas)
     */
    static async selecionarContexto(credentials) {
        const {
            id_usuario,
            id_sessao_usuario,
            id_unidade,
            id_local_operacional,
            id_perfil
        } = credentials;

        let conn;
        try {
            conn = await pool.getConnection();
            await conn.beginTransaction();

            // Validar sessão existente
            const [sessoes] = await conn.execute(
                `SELECT * FROM sessao_usuario 
                 WHERE id_sessao_usuario = ? AND id_usuario = ? AND ativo = 1`,
                [id_sessao_usuario, id_usuario]
            );

            if (sessoes.length === 0) {
                await conn.rollback();
                return { error: "SESSAO_INVALIDA" };
            }

            // Validar que o contexto pertence ao usuário (incluindo perfil escolhido)
            const [contextosValidos] = await conn.execute(
                `SELECT *
                 FROM usuario_contexto 
                 WHERE id_usuario = ?
                   AND id_unidade = ?
                   AND id_local_operacional = ?
                   AND id_perfil = ?
                   AND ativo = 1`,
                [id_usuario, id_unidade, id_local_operacional, id_perfil]
            );

            if (contextosValidos.length === 0) {
                await conn.rollback();
                return { error: "CONTEXTO_NAO_AUTORIZADO" };
            }

            const contextoSelecionado = contextosValidos[0];
            const idSistemaSelecionado = contextoSelecionado.id_sistema || 1;
            const idPerfilSelecionado = contextoSelecionado.id_perfil;

            // Atualizar sessão com novo contexto
            await conn.execute(
                `UPDATE sessao_usuario 
                 SET id_sistema = ?, id_unidade = ?, id_local_operacional = ?, id_perfil = ? 
                 WHERE id_sessao_usuario = ?`,
                [idSistemaSelecionado, id_unidade, id_local_operacional, idPerfilSelecionado, id_sessao_usuario]
            );

            // Atualizar contexto do usuário
            await conn.execute(
                `UPDATE usuario_contexto 
                 SET id_unidade = ?, id_local_operacional = ?, id_perfil = ? 
                 WHERE id_usuario = ? AND id_sistema = ?`,
                [id_unidade, id_local_operacional, idPerfilSelecionado, id_usuario, idSistemaSelecionado]
            );

            const [[usuario]] = await conn.execute(
                `SELECT login FROM usuario WHERE id_usuario = ? LIMIT 1`,
                [id_usuario]
            );

            const [[perfil]] = await conn.execute(
                `SELECT nome FROM perfil WHERE id_perfil = ? LIMIT 1`,
                [idPerfilSelecionado]
            );

            const tokenPayload = {
                id_usuario,
                login: usuario?.login || null,
                id_sessao_usuario,
                id_sistema: idSistemaSelecionado,
                id_unidade,
                id_local_operacional,
                id_perfil: idPerfilSelecionado,
                perfil: perfil?.nome || null
            };

            const token = jwt.sign(tokenPayload, SECRET, { expiresIn: EXPIRES_IN });

            await conn.commit();

            return { sucesso: true, token };

        } catch (err) {
            if (conn) await conn.rollback();
            throw err;
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Valida token e carrega contexto completo
     */
    static async validarToken(token) {
        try {
            const decoded = jwt.verify(token, SECRET);
            
            const conn = await pool.getConnection();
            try {
                // Carregar sessão
                const [sessoes] = await conn.execute(
                    `SELECT * FROM sessao_usuario 
                     WHERE id_sessao_usuario = ? AND ativo = 1 AND expiracao_em > NOW()`,
                    [decoded.id_sessao_usuario]
                );

                if (sessoes.length === 0) {
                    throw new Error("SESSAO_EXPIRADA");
                }

                const sessao = sessoes[0];

                // Carregar contexto completo
                const contexto = await LoginContextService._carregarContextoCompleto(
                    conn,
                    decoded.id_usuario,
                    decoded.id_unidade,
                    decoded.id_local_operacional
                );

                return {
                    valido: true,
                    usuario: {
                        id_usuario: decoded.id_usuario,
                        login: decoded.login
                    },
                    sessao: {
                        id_sessao_usuario: decoded.id_sessao_usuario,
                        token_runtime: sessao.token_runtime
                    },
                    contexto,
                    dispositivo: sessao.id_dispositivo ? {
                        id_dispositivo: sessao.id_dispositivo,
                        tipo: sessao.tipo_dispositivo
                    } : null
                };

            } finally {
                conn.release();
            }

        } catch (err) {
            return { valido: false, erro: err.message };
        }
    }

    /**
     * Encerra sessão
     */
    static async logout(id_sessao_usuario) {
        let conn;
        try {
            conn = await pool.getConnection();
            await conn.beginTransaction();
            
            await conn.execute(
                `UPDATE sessao_usuario SET ativo = 0 WHERE id_sessao_usuario = ?`,
                [id_sessao_usuario]
            );
            
            await conn.commit();
            return { sucesso: true };
        } catch (err) {
            if (conn) await conn.rollback();
            console.error('Erro ao fazer logout:', err);
            throw err;
        } finally {
            if (conn) conn.release();
        }
    }

    // ==============================
    // MÉTODOS PRIVADOS
    // ==============================

    /**
     * Buscar usuário por login
     */
    static async _buscarUsuario(conn, login) {
        const [usuarios] = await conn.execute(
            `SELECT * FROM usuario WHERE login = ? AND ativo = 1`,
            [login]
        );
        return usuarios[0] || null;
    }

    /**
     * Validar senha com bcrypt
     */
    static async _validarSenha(senha, senhaHash) {
        if (!senhaHash) {
            console.warn('Falha na validação: senha hash ausente');
            return false;
        }

        // ==============================
        // Caso bcrypt
        // ==============================
        if (senhaHash.startsWith('$2')) {
            try {
                const valida = await bcrypt.compare(senha, senhaHash);
                if (!valida) console.warn('Senha incorreta (bcrypt)');
                return valida;
            } catch (err) {
                console.error('Erro ao validar senha bcrypt:', err);
                return false;
            }
        }

        // ==============================
        // Caso SHA256 legado
        // ==============================
        const sha = crypto.createHash('sha256').update(senha).digest('hex');
        if (senhaHash === sha) {
            console.warn('Login usando hash SHA256 legado - considere migrar para bcrypt');
            return true;
        }

        // ==============================
        // Senha incorreta
        // ==============================
        console.warn('Senha incorreta (não corresponde a bcrypt nem SHA256 legado)');
        return false;
    }

    /**
     * Registrar falha de login
     */
    static async _registrarFalhaLogin(conn, id_usuario) {
        try {
            await conn.execute(
                `UPDATE usuario SET tentativas_login = tentativas_login + 1 WHERE id_usuario = ?`,
                [id_usuario]
            );
        } catch {}
    }

    /**
     * Validar dispositivo
     */
    static async _validarDispositivo(conn, id_dispositivo, token_dispositivo) {
        if (id_dispositivo) {
            const [dispositivos] = await conn.execute(
                `SELECT * FROM dispositivo WHERE id_dispositivo = ? AND ativo = 1`,
                [id_dispositivo]
            );
            return dispositivos[0] || null;
        }

        if (token_dispositivo) {
            const [dispositivos] = await conn.execute(
                `SELECT * FROM dispositivo WHERE token_auth = ? AND ativo = 1`,
                [token_dispositivo]
            );
            return dispositivos[0] || null;
        }

        return null;
    }

    /**
     * Selecionar contexto operacional
     * Se não existir contexto, cria um padrão automaticamente
     * Retorna objeto com contexto atual E lista de todos os contextos disponíveis
     */
    static async _selecionarContexto(conn, id_usuario, id_sistema, id_unidade, id_local_operacional) {
        // Se contexto fornecido, validar
        if (id_unidade && id_local_operacional) {
            let contexto;
            if (id_sistema) {
                [contexto] = await conn.execute(
                    `SELECT uc.*, p.nome as perfil_nome, u.nome as unidade_nome, lo.nome as local_nome
                     FROM usuario_contexto uc
                     JOIN perfil p ON p.id_perfil = uc.id_perfil
                     LEFT JOIN unidade u ON u.id_unidade = uc.id_unidade
                     LEFT JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
                     WHERE uc.id_usuario = ? AND uc.id_sistema = ? AND uc.id_unidade = ? AND uc.id_local_operacional = ? AND uc.ativo = 1`,
                    [id_usuario, id_sistema, id_unidade, id_local_operacional]
                );
            } else {
                [contexto] = await conn.execute(
                    `SELECT uc.*, p.nome as perfil_nome, u.nome as unidade_nome, lo.nome as local_nome
                     FROM usuario_contexto uc
                     JOIN perfil p ON p.id_perfil = uc.id_perfil
                     LEFT JOIN unidade u ON u.id_unidade = uc.id_unidade
                     LEFT JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
                     WHERE uc.id_usuario = ? AND uc.id_unidade = ? AND uc.id_local_operacional = ? AND uc.ativo = 1`,
                    [id_usuario, id_unidade, id_local_operacional]
                );
            }
            
            if (contexto.length > 0) {
                // Buscar todos os contextos do usuário para retornar na lista
                const [todosContextos] = await conn.execute(
                    `SELECT uc.id_sistema, uc.id_unidade, uc.id_local_operacional, uc.id_perfil, 
                            p.nome as perfil_nome, u.nome as unidade_nome, lo.nome as local_nome, lo.tipo as local_tipo
                     FROM usuario_contexto uc
                     JOIN perfil p ON p.id_perfil = uc.id_perfil
                     LEFT JOIN unidade u ON u.id_unidade = uc.id_unidade
                     LEFT JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
                     WHERE uc.id_usuario = ? AND uc.ativo = 1`,
                    [id_usuario]
                );
                return {
                    contextoAtual: contexto[0],
                    contextos: todosContextos
                };
            }
        }

        // Buscar TODOS os contextos disponíveis do usuário
        const [contextos] = await conn.execute(
            `SELECT uc.id_sistema, uc.id_unidade, uc.id_local_operacional, uc.id_perfil, 
                    p.nome as perfil_nome, u.nome as unidade_nome, lo.nome as local_nome, lo.tipo as local_tipo
             FROM usuario_contexto uc
             JOIN perfil p ON p.id_perfil = uc.id_perfil
             LEFT JOIN unidade u ON u.id_unidade = uc.id_unidade
             LEFT JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
             WHERE uc.id_usuario = ? AND uc.ativo = 1`,
            [id_usuario]
        );

        if (contextos.length === 0) {
            // Criar contexto padrão automaticamente se não existir
            // Busca unidade, local e perfil padrão
            const [[unidade]] = await conn.execute(
                `SELECT id_unidade FROM unidade WHERE ativo = 1 LIMIT 1`
            );
            
            const [[local]] = await conn.execute(
                `SELECT id_local_operacional FROM local_operacional WHERE ativo = 1 LIMIT 1`
            );
            
            const [[perfil]] = await conn.execute(
                `SELECT id_perfil, nome as perfil_nome FROM perfil WHERE ativo = 1 ORDER BY id_perfil ASC LIMIT 1`
            );

            if (unidade && local && perfil) {
                // Cria o contexto
                await conn.execute(
                    `INSERT INTO usuario_contexto (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, ativo)
                     VALUES (?, 1, ?, ?, ?, 1)`,
                    [id_usuario, unidade.id_unidade, local.id_local_operacional, perfil.id_perfil]
                );

                const novoContexto = {
                    id_sistema: 1,
                    id_unidade: unidade.id_unidade,
                    id_local_operacional: local.id_local_operacional,
                    id_perfil: perfil.id_perfil,
                    perfil_nome: perfil.perfil_nome,
                    unidade_nome: unidade.nome,
                    local_nome: local.nome
                };
                
                return {
                    contextoAtual: novoContexto,
                    contextos: [novoContexto]
                };
            }

            return null;
        }

        if (contextos.length === 1) {
            // Retornar o contexto único com a lista
            return {
                contextoAtual: contextos[0],
                contextos: contextos
            };
        }

        // Múltiplos contextos: retornar lista para o frontend decidir
        // Por padrão, usa o primeiro contexto mas retorna todos para possibilidade de mudança
        return {
            contextoAtual: contextos[0],
            contextos: contextos
        };
    }

    /**
     * Criar sessão usando Stored Procedure
     */
    static async _criarSessao(conn, id_usuario, contexto, dispositivo, ip_acesso, user_agent) {
        const token_runtime = crypto.randomBytes(32).toString("hex");
        const horas = parseInt(EXPIRES_IN, 10) || 8;
        const expira_em = new Date(Date.now() + horas * 60 * 60 * 1000);

        // Inserir sessão diretamente (sem usar SP)
        const [result] = await conn.execute(
            `INSERT INTO sessao_usuario 
            (id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, token_jwt, ip_origem, user_agent, iniciado_em, expira_em, ativo)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, 1)`,
            [
                id_usuario,
                contexto.id_sistema || 1,
                contexto.id_unidade || null,
                contexto.id_local_operacional || null,
                contexto.id_perfil || null,
                token_runtime,
                ip_acesso || null,
                user_agent || null,
                expira_em
            ]
        );

        const id_sessao = result.insertId;

        // Busca os dados da sessão criada
        const [[sessao]] = await conn.execute(
            `SELECT id_sessao_usuario, token_jwt, expira_em 
             FROM sessao_usuario 
             WHERE id_sessao_usuario = ?`,
            [id_sessao]
        );

        return {
            id_sessao_usuario: sessao.id_sessao_usuario,
            token_runtime: sessao.token_jwt,
            expira_em: sessao.expira_em
        };
    }

    /**
     * Atualizar contexto do usuário
     */
    static async _atualizarContextoUsuario(conn, id_usuario, contexto, id_sessao) {
        // Não precisa atualizar - o contexto já existe
        // A tabela usuario_contexto não tem id_entidade
    }

    /**
     * Buscar runtime parrudo - estrutura completa com todos os perfis, contextos, filas e acessos
     * Versão canônica para todo o HIS/PA
     */
    static async _buscarRuntimeParrudo(conn, id_usuario) {
        // 1. Buscar todos os perfis do usuário
        const [perfisUsuario] = await conn.execute(
            `SELECT DISTINCT p.id_perfil, p.nome as perfil
             FROM usuario_perfil up
             JOIN perfil p ON p.id_perfil = up.id_perfil
             WHERE up.id_usuario = ? AND p.ativo = 1`,
            [id_usuario]
        );

        // 2. Para cada perfil, buscar todos os contextos do usuário
        const perfisCompletos = [];
        
        for (const perfil of perfisUsuario) {
            // Buscar contextos deste perfil para este usuário
            const [contextos] = await conn.execute(
                `SELECT 
                    uc.id_unidade,
                    uc.id_local_operacional,
                    u.nome as unidade_nome,
                    lo.nome as local_nome,
                    lo.tipo as local_tipo
                 FROM usuario_contexto uc
                 JOIN unidade u ON u.id_unidade = uc.id_unidade
                 JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
                 WHERE uc.id_usuario = ? 
                   AND uc.id_perfil = ? 
                   AND uc.ativo = 1`,
                [id_usuario, perfil.id_perfil]
            );

            // Para cada contexto, buscar filas e acessos
            const contextosCompletos = [];
            for (const ctx of contextos) {
                // Buscar filas deste local operacional
                const [filas] = await conn.execute(
                    `SELECT nome FROM fila_operacional 
                     WHERE id_local_operacional = ? AND ativo = 1`,
                    [ctx.id_local_operacional]
                );

                // Buscar acessos/permissões deste perfil
                const [permissoes] = await conn.execute(
                    `SELECT p.acao 
                     FROM perfil_permissao pp
                     JOIN permissao p ON p.id_permissao = pp.id_permissao
                     WHERE pp.id_perfil = ?`,
                    [perfil.id_perfil]
                );

                // Buscar especialidades médicas se for perfil médico
                let especialidades = [];
                if (perfil.perfil.toUpperCase().includes('MEDICO') || perfil.perfil.toUpperCase().includes('CLINICO')) {
                    const [especialidadesRows] = await conn.execute(
                        `SELECT e.id_especialidade, e.nome, e.cbo 
                         FROM medico_especialidade me
                         JOIN especialidade e ON e.id_especialidade = me.id_especialidade
                         WHERE me.id_usuario = ?`,
                        [id_usuario]
                    );
                    especialidades = especialidadesRows;
                }

                contextosCompletos.push({
                    id_unidade: ctx.id_unidade,
                    id_local_operacional: ctx.id_local_operacional,
                    descricao: ctx.local_nome || ctx.unidade_nome,
                    filas: filas.map(f => f.nome),
                    acessos: permissoes.map(p => p.acao),
                    especialidades: especialidades.length > 0 ? especialidades : undefined
                });
            }

            // Se o usuário não tem contextos, criar um padrão vazio
            if (contextosCompletos.length === 0) {
                contextosCompletos.push({
                    id_unidade: 1,
                    id_local_operacional: 1,
                    descricao: "Sem contexto",
                    filas: [],
                    acessos: []
                });
            }

            perfisCompletos.push({
                id_perfil: perfil.id_perfil,
                perfil: perfil.perfil,
                contextos: contextosCompletos
            });
        }

        // Se o usuário não tem perfis, retornar estrutura vazia
        if (perfisCompletos.length === 0) {
            return [{
                id_perfil: 0,
                perfil: "Sem Perfil",
                contextos: [{
                    id_unidade: 1,
                    id_local_operacional: 1,
                    descricao: "Sem contexto",
                    filas: [],
                    acessos: []
                }]
            }];
        }

        return perfisCompletos;
    }

    /**
     * Buscar perfis do usuário (versão simples)
     * @deprecated Use _buscarRuntimeParrudo para estrutura completa
     */
    static async _buscarPerfis(conn, id_usuario) {
        const [perfis] = await conn.execute(
            `SELECT p.id_perfil, p.nome
             FROM usuario_perfil up
             JOIN perfil p ON p.id_perfil = up.id_perfil
             WHERE up.id_usuario = ? AND p.ativo = 1`,
            [id_usuario]
        );
        return perfis;
    }

    /**
     * Buscar permissões do perfil
     */
    static async _buscarPermissoes(conn, id_perfil) {
        // Retorna array vazio - a estrutura de permissões não está completa no banco
        // O sistema usa perfil diretamente sem permissões granulares
        return [];
    }

    /**
     * Buscar dados completos do contexto
     */
    static async _buscarDadosContexto(conn, id_unidade, id_local_operacional, dispositivo) {
        const resultado = {};

        // Unidade
        if (id_unidade) {
            const [unidades] = await conn.execute(
                `SELECT * FROM unidade WHERE id_unidade = ?`,
                [id_unidade]
            );
            resultado.unidade = unidades[0] || null;
        }

        // Local operacional
        if (id_local_operacional) {
            const [locais] = await conn.execute(
                `SELECT * FROM local_operacional WHERE id_local_operacional = ?`,
                [id_local_operacional]
            );
            resultado.local = locais[0] || null;
        }

        // Dispositivo
        if (dispositivo?.id_dispositivo) {
            const [dispositivos] = await conn.execute(
                `SELECT d.*, dt.nome as tipo_nome
                 FROM dispositivo d
                 LEFT JOIN dispositivo_tipo dt ON dt.nome = d.tipo
                 WHERE d.id_dispositivo = ?`,
                [dispositivo.id_dispositivo]
            );
            resultado.dispositivo = dispositivos[0] || null;
        }

        return resultado;
    }

    /**
     * Carregar contexto completo para validação de token
     */
    static async _carregarContextoCompleto(conn, id_usuario, id_unidade, id_local_operacional) {
        const [dados] = await conn.execute(
            `SELECT 
                u.id_usuario,
                u.login,
                uc.id_unidade,
                un.nome as unidade_nome,
                uc.id_local_operacional,
                lo.nome as local_nome,
                uc.id_perfil,
                p.nome as perfil_nome
             FROM usuario u
             JOIN usuario_contexto uc ON uc.id_usuario = u.id_usuario
             JOIN unidade un ON un.id_unidade = uc.id_unidade
             JOIN local_operacional lo ON lo.id_local_operacional = uc.id_local_operacional
             JOIN perfil p ON p.id_perfil = uc.id_perfil
             WHERE u.id_usuario = ? AND uc.id_unidade = ? AND uc.id_local_operacional = ?`,
            [id_usuario, id_unidade, id_local_operacional]
        );

        return dados[0] || null;
    }

    /**
     * Atualiza runtime com pacientes em espera (FFA) - Versão Parruda
     * Adiciona pacientes das filas ao contexto do usuário
     */
    static async _atualizarRuntimeFilasPacientes(conn, id_usuario, id_unidade, id_local_operacional) {
        try {
            // Buscar filas ativas do local
            const [filas] = await conn.execute(
                `SELECT id_fila_operacional, nome FROM fila_operacional 
                 WHERE id_unidade = ? AND id_local_operacional = ? AND ativo = 1`,
                [id_unidade, id_local_operacional]
            );

            const filasComPacientes = [];
            for (const fila of filas) {
                // Buscar pacientes em espera (FFA)
                const [pacientes] = await conn.execute(
                    `SELECT id_ffa, nome_paciente, status, urgencia, data_chegada
                     FROM ffa
                     WHERE id_unidade = ? AND id_local_operacional = ? AND id_fila_operacional = ? 
                       AND status IN ('EM_ESPERA', 'EM_TRIAGEM')
                     ORDER BY urgencia DESC, data_chegada ASC`,
                    [id_unidade, id_local_operacional, fila.id_fila_operacional]
                );
                filasComPacientes.push({ 
                    id_fila: fila.id_fila_operacional, 
                    nome_fila: fila.nome, 
                    pacientes 
                });
            }
            return filasComPacientes;
        } catch (err) {
            console.error("Erro ao buscar pacientes nas filas:", err);
            return [];
        }
    }
}

module.exports = LoginContextService;
