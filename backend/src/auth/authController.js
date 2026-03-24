const pool = require("../config/database");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { SECRET, EXPIRES_IN } = require("../config/jwt");
const { registrarEventoAuditoria } = require("../services/auditoria_service");
const { executeSPMaster } = require("../services/spMasterService");

class AuthController {
    static async checkUser(req, res) {
        const { usuario, login } = req.body;
        const user = usuario || login;
        if (!user) return res.status(400).json({ sucesso: false, erro: "LOGIN_OBRIGATORIO" });
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute("SELECT id_usuario, login, ativo FROM usuario WHERE login = ? LIMIT 1", [user]);
            if (!rows.length) return res.json({ sucesso: false, existe: false });
            return res.json({ sucesso: true, existe: true, usuario: { id_usuario: rows[0].id_usuario, login: rows[0].login, ativo: !!rows[0].ativo } });
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_DE_CONEXAO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async login(req, res) {
        const { login, usuario, senha, ip: reqIp, device } = req.body;
        const userLogin = login || usuario;
        const ip = reqIp || req.headers["x-forwarded-for"] || req.socket.remoteAddress || '0.0.0.0';
        const userAgent = device || req.headers["user-agent"] || 'unknown';

        if (!userLogin || !senha) {
            return res.json({ sucesso: false, erro: "CREDENCIAIS_OBRIGATORIAS", mensagem: "Login e senha são obrigatórios" });
        }

        let conn;
        try {
            conn = await pool.getConnection();
            
            // 1. Validar usuário e senha manualmente (bcrypt está no Node)
            const [userRows] = await conn.execute(
                "SELECT id_usuario, login, senha_hash, ativo FROM usuario WHERE login = ? LIMIT 1", 
                [userLogin]
            );

            if (!userRows.length) {
                return res.json({ sucesso: false, erro: "USUARIO_NAO_ENCONTRADO", mensagem: "Usuário não encontrado" });
            }

            const user = userRows[0];
            if (user.ativo !== 1) {
                return res.json({ sucesso: false, erro: "USUARIO_INATIVO", mensagem: "Usuário inativo" });
            }

            const senhaValida = await bcrypt.compare(senha, user.senha_hash);
            if (!senhaValida) {
                await conn.execute(
                    "INSERT INTO login_tentativa (id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em) VALUES (?, ?, ?, ?, 0, ?, NOW(6))",
                    [user.id_usuario, userLogin, ip, userAgent.substring(0, 100), JSON.stringify({ motivo: 'senha_invalida' })]
                );
                return res.json({ sucesso: false, erro: "SENHA_INVALIDA", mensagem: "Senha incorreta" });
            }

            // 2. Criar Tokens Primeiro (precisamos do token_jwt para a sessão)
            const jwtToken = jwt.sign({ 
                id_usuario: user.id_usuario, 
                id_sessao_usuario: 0, // Será atualizado após criar sessão
                login: user.login
            }, SECRET, { expiresIn: EXPIRES_IN });

            const refreshToken = jwt.sign({ 
                id_usuario: user.id_usuario, 
                id_sessao_usuario: 0,
                login: user.login,
                tipo: 'refresh'
            }, SECRET, { expiresIn: '7d' });

            // Criar Sessão diretamente no banco (sem dependência de SP)
            // Inserir registro na tabela sessao_usuario
            const [sessaoResult] = await conn.execute(
                `INSERT INTO sessao_usuario (uuid_sessao, id_usuario, id_sistema, id_perfil, id_unidade, id_local, token_jwt, refresh_token, ip_origem, user_agent, iniciado_em, expira_em, ativo) 
                 VALUES (UUID(), ?, 4, NULL, NULL, NULL, ?, ?, ?, ?, NOW(6), DATE_ADD(NOW(6), INTERVAL 8 HOUR), 1)`,
                [user.id_usuario, jwtToken, refreshToken, ip, userAgent.substring(0, 255)]
            );
            
            const id_sessao_usuario = sessaoResult.insertId;
            
            // Registrar tentativa de login bem-sucedida
            await conn.execute(
                `INSERT INTO login_tentativa (id_usuario, login, ip_origem, dispositivo_origem, sucesso, metadata, criado_em) 
                 VALUES (?, ?, ?, ?, 1, ?, NOW(6))`,
                [user.id_usuario, userLogin, ip, userAgent.substring(0, 100), JSON.stringify({ status: 'sucesso' })]
            );

            // 3. Atualizar token com id_sessao_usuario correto
            const jwtTokenFinal = jwt.sign({ 
                id_usuario: user.id_usuario, 
                id_sessao_usuario: id_sessao_usuario,
                login: user.login
            }, SECRET, { expiresIn: EXPIRES_IN });

            const refreshTokenFinal = jwt.sign({ 
                id_usuario: user.id_usuario, 
                id_sessao_usuario: id_sessao_usuario,
                login: user.login,
                tipo: 'refresh'
            }, SECRET, { expiresIn: '7d' });

            // Atualizar sessão com os tokens corretos
            await conn.execute(
                `UPDATE sessao_usuario SET token_jwt = ?, refresh_token = ? WHERE id_sessao_usuario = ?`,
                [jwtTokenFinal, refreshTokenFinal, id_sessao_usuario]
            );

            return res.json({ 
                sucesso: true, 
                sessao: { 
                    id_sessao_usuario, 
                    id_usuario: user.id_usuario,
                    contexto_definido: false // Fluxo canônico: login não define contexto
                }, 
                usuario: { id_usuario: user.id_usuario, login: user.login },
                token: jwtTokenFinal,
                refreshToken: refreshTokenFinal
            });

        } catch (err) {
            console.error("Erro no fluxo de login:", err);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Listar contextos disponíveis
     */
    static async listarContextos(req, res) {
        const id_sessao = req.user?.id_sessao_usuario;
        if (!id_sessao) return res.status(401).json({ erro: "SESSAO_NAO_ENCONTRADA" });

        let conn;
        try {
            conn = await pool.getConnection();
            
            // Buscar ID do usuário pela sessão
            const [sessoes] = await conn.query(
                "SELECT id_usuario FROM sessao_usuario WHERE id_sessao_usuario = ? AND ativo = 1 AND expira_em > NOW()",
                [id_sessao]
            );
            
            if (!sessoes.length) {
                return res.json({ unidades: [], locais: [], perfis: [], salas: [], especialidades: [] });
            }
            
            const id_usuario = sessoes[0].id_usuario;
            
            // Buscar se é admin
            const [isAdminResult] = await conn.query(
                "SELECT COUNT(*) as isAdmin FROM usuario_perfil WHERE id_usuario = ? AND id_perfil = 42",
                [id_usuario]
            );
            const isAdmin = isAdminResult[0]?.isAdmin > 0;
            
            // Buscar unidades (todas se admin, ou vinculadas)
            let unidades;
            if (isAdmin) {
                const [rows] = await conn.query("SELECT id_unidade, nome FROM unidade WHERE ativo = 1 ORDER BY nome");
                unidades = rows;
            } else {
                const [rows] = await conn.query(
                    `SELECT u.id_unidade, u.nome 
                     FROM usuario_unidade uu 
                     JOIN unidade u ON u.id_unidade = uu.id_unidade 
                     WHERE uu.id_usuario = ? AND uu.ativo = 1 AND u.ativo = 1`,
                    [id_usuario]
                );
                unidades = rows;
            }
            
            // Buscar locais (setores) com tipo
            const [locais] = await conn.query(
                `SELECT l.id_local, l.nome, l.codigo, tl.nome as tipo_nome, tl.categoria 
                 FROM usuario_local ulo 
                 JOIN local l ON l.id_local = ulo.id_local 
                 LEFT JOIN tipo_local tl ON tl.id_tipo_local = l.id_tipo_local
                 WHERE ulo.id_usuario = ? AND ulo.ativo = 1`,
                [id_usuario]
            );
            
            // Buscar perfis
            const [perfis] = await conn.query(
                `SELECT p.id_perfil, p.nome 
                 FROM usuario_perfil up 
                 JOIN perfil p ON p.id_perfil = up.id_perfil 
                 WHERE up.id_usuario = ?`,
                [id_usuario]
            );
            
            // Buscar especialidades do usuário
            let especialidades;
            if (isAdmin) {
                const [rows] = await conn.query("SELECT id_especialidade as id, nome FROM especialidade ORDER BY nome");
                especialidades = rows;
            } else {
                // Tenta buscar de medico_especialidade
                const [rows] = await conn.query(
                    `SELECT e.id_especialidade as id, e.nome 
                     FROM medico_especialidade me 
                     JOIN especialidade e ON e.id_especialidade = me.id_especialidade 
                     WHERE me.id_usuario = ?
                     ORDER BY e.nome`,
                    [id_usuario]
                );
                especialidades = rows.length > 0 ? rows : [
                    { id: 1, nome: "CLINICA GERAL" },
                    { id: 2, nome: "PEDIATRIA" },
                    { id: 3, nome: "EMERGENCIA" }
                ];
            }
            
            // Buscar salas com tipo_sala para agrupamento
            let salas;
            if (isAdmin) {
                const [rows] = await conn.query(
                    `SELECT s.id_sala, s.nome_exibicao as nome, s.codigo, ts.nome as tipo_nome, ts.codigo as tipo_codigo
                     FROM sala s
                     LEFT JOIN tipo_sala ts ON ts.id_tipo_sala = s.id_tipo_sala
                     WHERE s.ativa = 1
                     ORDER BY ts.nome, s.nome_exibicao`
                );
                // Adicionar NÃO DEFINIDA como primeira opção
                salas = [{ id_sala: -1, nome: "NÃO DEFINIDA", tipo_nome: "GERAL", tipo_codigo: "NAO_DEFINIDA" }, ...rows];
            } else {
                // Salas do usuário via usuario_sala
                const [rows] = await conn.query(
                    `SELECT s.id_sala, s.nome_exibicao as nome, s.codigo, ts.nome as tipo_nome, ts.codigo as tipo_codigo
                     FROM usuario_sala us
                     JOIN sala s ON s.id_sala = us.id_sala
                     LEFT JOIN tipo_sala ts ON ts.id_tipo_sala = s.id_tipo_sala
                     WHERE us.id_usuario = ? AND us.ativo = 1 AND s.ativa = 1
                     ORDER BY ts.nome, s.nome_exibicao`,
                    [id_usuario]
                );
                // Se não tem sala alocada, mostra opções padrões
                if (rows.length > 0) {
                    salas = [{ id_sala: -1, nome: "NÃO DEFINIDA", tipo_nome: "GERAL", tipo_codigo: "NAO_DEFINIDA" }, ...rows];
                } else {
                    salas = [
                        { id_sala: -1, nome: "NÃO DEFINIDA", tipo_nome: "GERAL", tipo_codigo: "NAO_DEFINIDA" },
                        { id_sala: 1, nome: "CLINICO", tipo_nome: "CONSULTÓRIO", tipo_codigo: "CONSULTORIO" },
                        { id_sala: 2, nome: "PEDIATRICO", tipo_nome: "CONSULTÓRIO", tipo_codigo: "CONSULTORIO" },
                        { id_sala: 3, nome: "EMERGENCIA", tipo_nome: "EMERGÊNCIA", tipo_codigo: "EMERGENCIA" }
                    ];
                }
            }
            
            return res.json({
                unidades: unidades || [],
                locais: locais || [],
                perfis: perfis || [],
                salas: salas,
                especialidades: especialidades || []
            });
        } catch (err) {
            console.error("Erro listarContextos:", err.message);
            return res.json({ unidades: [], locais: [], perfis: [], salas: [], especialidades: [] });
        } finally {
            if (conn) conn.release();
        }
    }

    static async selecionarContexto(req, res) {
        const { id_unidade, id_local, id_perfil, id_sala } = req.body;
        const id_sessao = req.user?.id_sessao_usuario;
        const id_usuario = req.user?.id_usuario;
        
        if (!id_usuario || !id_sessao) {
            return res.status(401).json({ sucesso: false, erro: "USUARIO_NAO_AUTENTICADO" });
        }
        
        if (!id_unidade || !id_perfil) {
            return res.status(400).json({ sucesso: false, erro: "CAMPOS_OBRIGATORIOS" });
        }
        
        try {
            const payload = { 
                id_sessao: id_sessao,
                id_unidade: parseInt(id_unidade), 
                id_local: id_local ? parseInt(id_local) : null, 
                id_perfil: parseInt(id_perfil),
                id_sala: id_sala ? parseInt(id_sala) : null
            };

            // Regra Canônica: Node (thin layer) -> sp_master_dispatcher -> AUTH.CONTEXTO.SET
            const resultado = await executeSPMaster("AUTH", "CONTEXTO.SET", id_sessao, payload);
            
            if (resultado.sucesso) {
                // Atualizar o JWT token com o contexto AGORA definido
                const jwtToken = jwt.sign({ 
                    id_usuario: id_usuario, 
                    id_sessao_usuario: id_sessao,
                    login: req.user?.login,
                    id_unidade: id_unidade, 
                    id_local_operacional: payload.id_local, 
                    id_perfil: id_perfil,
                    id_sala: payload.id_sala
                }, SECRET, { expiresIn: EXPIRES_IN });
                
                return res.json({ 
                    sucesso: true, 
                    token: jwtToken,
                    mensagem: 'CONTEXTO_DEFINIDO'
                });
            } else {
                return res.json({ sucesso: false, erro: resultado.mensagem || 'ERRO_AO_DEFINIR_CONTEXTO' });
            }
        } catch (err) {
            console.error('Erro ao selecionar contexto dispatcher:', err);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        }
    }

    static async getMenu(req, res) {
        const id_sessao = req.user?.id_sessao_usuario;
        try {
            const resultado = await executeSPMaster("GET", "AUTH.MENU", id_sessao);
            return res.json({ sucesso: true, resultado: resultado.resultado });
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        }
    }

    static async me(req, res) {
        const id_usuario = req.user?.id_usuario;
        if (!id_usuario) return res.status(401).json({ erro: "NAO_AUTENTICADO" });
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute("SELECT id_usuario, login, ativo FROM usuario WHERE id_usuario = ?", [id_usuario]);
            if (!rows.length) return res.status(404).json({ erro: "USUARIO_NAO_ENCONTRADO" });
            return res.json({ sucesso: true, usuario: rows[0] });
        } catch (err) {
            return res.status(500).json({ erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async logout(req, res) {
        const id_sessao = req.user?.id_sessao_usuario;
        let conn;
        try {
            conn = await pool.getConnection();
            // Deletar sessão diretamente
            await conn.execute(
                "UPDATE sessao_usuario SET ativo = 0 WHERE id_sessao_usuario = ?",
                [id_sessao]
            );
            return res.json({ sucesso: true, mensagem: "Logout realizado" });
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }

    static async refreshToken(req, res) {
        const { refreshToken: token } = req.body;
        if (!token) return res.json({ sucesso: false, erro: "REFRESH_TOKEN_OBRIGATORIO" });
        try {
            const decoded = jwt.verify(token, SECRET);
            let conn;
            try {
                conn = await pool.getConnection();
                const [rows] = await conn.execute(
                    "SELECT id_sessao_usuario, ativo, expira_em, id_unidade, id_local, id_perfil FROM sessao_usuario WHERE id_sessao_usuario = ?",
                    [decoded.id_sessao_usuario]
                );
                if (!rows.length || rows[0].ativo !== 1) return res.json({ sucesso: false, erro: "SESSAO_INATIVA" });
                const sessao = rows[0];
                const newToken = jwt.sign({ 
                    id_usuario: decoded.id_usuario, 
                    id_sessao_usuario: decoded.id_sessao_usuario,
                    login: decoded.login,
                    id_unidade: sessao.id_unidade,
                    id_local_operacional: sessao.id_local,
                    id_perfil: sessao.id_perfil
                }, SECRET, { expiresIn: EXPIRES_IN });
                return res.json({ sucesso: true, token: newToken, id_sessao_usuario: decoded.id_sessao_usuario });
            } finally {
                if (conn) conn.release();
            }
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        }
    }

    static async contextoAtual(req, res) {
        return res.json({ sucesso: true, contexto: req.contexto });
    }

    static async sync(req, res) {
        return res.json({ sucesso: true, sincronizado: true });
    }

    /**
     * Meus contextos disponíveis
     */
    static async meusContextosSP(req, res) {
        const id_sessao = req.user?.id_sessao_usuario;
        if (!id_sessao) return res.status(401).json({ erro: "SESSAO_NAO_ENCONTRADA" });

        let conn;
        try {
            conn = await pool.getConnection();
            
            // Buscar ID do usuário pela sessão
            const [sessoes] = await conn.query(
                "SELECT id_usuario FROM sessao_usuario WHERE id_sessao_usuario = ? AND ativo = 1 AND expira_em > NOW()",
                [id_sessao]
            );
            
            if (!sessoes.length) {
                return res.json({ unidades: [], locais: [], perfis: [], salas: [], especialidades: [] });
            }
            
            const id_usuario = sessoes[0].id_usuario;
            
            // Buscar se é admin
            const [isAdminResult] = await conn.query(
                "SELECT COUNT(*) as isAdmin FROM usuario_perfil WHERE id_usuario = ? AND id_perfil = 42",
                [id_usuario]
            );
            const isAdmin = isAdminResult[0]?.isAdmin > 0;
            
            // Buscar unidades
            let unidades;
            if (isAdmin) {
                const [rows] = await conn.query("SELECT id_unidade, nome FROM unidade WHERE ativo = 1 ORDER BY nome");
                unidades = rows;
            } else {
                const [rows] = await conn.query(
                    `SELECT u.id_unidade, u.nome 
                     FROM usuario_unidade uu 
                     JOIN unidade u ON u.id_unidade = uu.id_unidade 
                     WHERE uu.id_usuario = ? AND uu.ativo = 1 AND u.ativo = 1`,
                    [id_usuario]
                );
                unidades = rows;
            }
            
            // Buscar locais
            const [locais] = await conn.query(
                `SELECT lo.id_local, lo.nome 
                 FROM usuario_local ulo 
                 JOIN local lo ON lo.id_local = ulo.id_local 
                 WHERE ulo.id_usuario = ? AND ulo.ativo = 1`,
                [id_usuario]
            );
            
            // Buscar perfis
            const [perfis] = await conn.query(
                `SELECT p.id_perfil, p.nome 
                 FROM usuario_perfil up 
                 JOIN perfil p ON p.id_perfil = up.id_perfil 
                 WHERE up.id_usuario = ?`,
                [id_usuario]
            );
            
            // Buscar especialidades
            let especialidades;
            if (isAdmin) {
                const [rows] = await conn.query("SELECT id_especialidade as id, nome FROM especialidade ORDER BY nome");
                especialidades = rows;
            } else {
                const [rows] = await conn.query(
                    `SELECT e.id_especialidade as id, e.nome 
                     FROM medico_especialidade me 
                     JOIN especialidade e ON e.id_especialidade = me.id_especialidade 
                     WHERE me.id_usuario = ?
                     ORDER BY e.nome`,
                    [id_usuario]
                );
                especialidades = rows.length > 0 ? rows : [
                    { id: 1, nome: "CLINICA GERAL" },
                    { id: 2, nome: "PEDIATRIA" },
                    { id: 3, nome: "EMERGENCIA" }
                ];
            }
            
            // Buscar salas
            let salas;
            if (isAdmin) {
                const [rows] = await conn.query(
                    "SELECT id_sala, nome_exibicao as nome FROM sala WHERE ativa = 1 ORDER BY nome_exibicao"
                );
                salas = [{ id_sala: -1, nome: "NÃO DEFINIDA" }, ...rows];
            } else {
                const [rows] = await conn.query(
                    `SELECT s.id_sala, s.nome_exibicao as nome 
                     FROM usuario_alocacao ua 
                     JOIN sala s ON s.id_sala = ua.id_sala 
                     WHERE ua.id_usuario = ? AND ua.fim IS NULL AND s.ativa = 1
                     ORDER BY s.nome_exibicao`,
                    [id_usuario]
                );
                salas = rows.length > 0 
                    ? [{ id_sala: -1, nome: "NÃO DEFINIDA" }, ...rows]
                    : [
                        { id_sala: -1, nome: "NÃO DEFINIDA" },
                        { id_sala: 1, nome: "CLINICO" },
                        { id_sala: 2, nome: "PEDIATRICO" },
                        { id_sala: 3, nome: "EMERGENCIA" }
                      ];
            }
            
            return res.json({
                unidades: unidades || [],
                locais: locais || [],
                perfis: perfis || [],
                salas: salas,
                especialidades: especialidades || []
            });
        } catch (err) {
            console.error("Erro meusContextosSP:", err.message);
            return res.json({ unidades: [], locais: [], perfis: [], salas: [], especialidades: [] });
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Permissões por perfil
     */
    static async permissoesPorPerfil(req, res) {
        const { idPerfil } = req.params;
        let conn;
        try {
            conn = await pool.getConnection();
            const [rows] = await conn.execute(
                `SELECT p.codigo, p.nome, p.descricao 
                 FROM perfil_permissao pp
                 JOIN permissao p ON p.id_permissao = pp.id_permissao
                 WHERE pp.id_perfil = ? AND pp.ativo = 1`,
                [idPerfil]
            );
            return res.json({ sucesso: true, permissoes: rows });
        } catch (err) {
            console.error("Erro permissoesPorPerfil:", err.message);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO" });
        } finally {
            if (conn) conn.release();
        }
    }
}

module.exports = AuthController;
