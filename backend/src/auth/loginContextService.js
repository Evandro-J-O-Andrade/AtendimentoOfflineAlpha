/**
 * ================================================================
 * Login Context Service
 * ================================================================
 * 
 * Serviço de contexto de login para o sistema HIS offline-first.
 * Implementa a arquitetura de autenticação com:
 * - Identidade (usuário, perfil)
 * - Sessão (sessão auditável)
 * - Contexto (unidade, local, dispositivo)
 * - Runtime (motor clínico)
 * 
 * @version 1.0.0
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
            const contexto = await LoginContextService._selecionarContexto(
                conn, 
                user.id_usuario, 
                id_sistema,
                id_unidade, 
                id_local_operacional
            );

            if (!contexto) {
                await conn.rollback();
                return { error: "USUARIO_SEM_CONTEXTO" };
            }

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
            // PASSO 7: Buscar perfis e permissões
            // ==============================
            const perfis = await LoginContextService._buscarPerfis(conn, user.id_usuario);
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
                permissoes: permissoes.map(p => p.acao)
            };

            const token = jwt.sign(tokenPayload, SECRET, { expiresIn: EXPIRES_IN });

            return {
                token,
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
                    unidade_nome: dadosContexto.unidade?.nome,
                    id_local_operacional: contexto.id_local_operacional,
                    local_nome: dadosContexto.local?.nome,
                    id_perfil: contexto.id_perfil,
                    perfil: contexto.perfil_nome
                },
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
        if (!senhaHash) return false;

        // Tentar bcrypt
        if (senhaHash.startsWith('$2')) {
            try {
                return await bcrypt.compare(senha, senhaHash);
            } catch (err) {
                console.error('Erro ao validar senha bcrypt:', err);
                return false;
            }
        }

        // Hash SHA256 legado
        const sha = crypto.createHash('sha256').update(senha).digest('hex');
        if (senhaHash === sha) {
            console.warn('AVISO: Usando hash SHA256 legado - considere migrar para bcrypt');
            return true;
        }

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
     */
    static async _selecionarContexto(conn, id_usuario, id_sistema, id_unidade, id_local_operacional) {
        // Se contexto fornecido, validar
        if (id_unidade && id_local_operacional) {
            let contexto;
            if (id_sistema) {
                [contexto] = await conn.execute(
                    `SELECT uc.*, p.nome as perfil_nome
                     FROM usuario_contexto uc
                     JOIN perfil p ON p.id_perfil = uc.id_perfil
                     WHERE uc.id_usuario = ? AND uc.id_sistema = ? AND uc.id_unidade = ? AND uc.id_local_operacional = ? AND uc.ativo = 1`,
                    [id_usuario, id_sistema, id_unidade, id_local_operacional]
                );
            } else {
                [contexto] = await conn.execute(
                    `SELECT uc.*, p.nome as perfil_nome
                     FROM usuario_contexto uc
                     JOIN perfil p ON p.id_perfil = uc.id_perfil
                     WHERE uc.id_usuario = ? AND uc.id_unidade = ? AND uc.id_local_operacional = ? AND uc.ativo = 1`,
                    [id_usuario, id_unidade, id_local_operacional]
                );
            }
            
            if (contexto.length > 0) {
                return contexto[0];
            }
        }

        // Buscar contextos disponíveis
        const [contextos] = await conn.execute(
            `SELECT uc.*, p.nome as perfil_nome
             FROM usuario_contexto uc
             JOIN perfil p ON p.id_perfil = uc.id_perfil
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

                return {
                    id_sistema: 1,
                    id_unidade: unidade.id_unidade,
                    id_local_operacional: local.id_local_operacional,
                    id_perfil: perfil.id_perfil,
                    perfil_nome: perfil.perfil_nome
                };
            }

            return null;
        }

        if (contextos.length === 1) {
            return contextos[0];
        }

        // Fluxo padrao: autentica e envia para tela de contexto apos login.
        // Para isso, inicializa sessao com o primeiro contexto valido.
        return contextos[0];
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
     * Buscar perfis do usuário
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
}

module.exports = LoginContextService;
