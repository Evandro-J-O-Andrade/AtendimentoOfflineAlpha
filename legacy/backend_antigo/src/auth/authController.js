const pool = require("../config/database");
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
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
            const [rows] = await conn.execute("SELECT id_usuario, id_pessoa, login, ativo, id_entidade FROM usuario WHERE login = ? LIMIT 1", [user]);
            if (!rows.length) return res.json({ sucesso: false, existe: false });
            const u = rows[0];
            return res.json({ sucesso: true, existe: true, usuario: { id_usuario: u.id_usuario, id_pessoa: u.id_pessoa, login: u.login, ativo: !!u.ativo } });
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
            
            // 1. Obter detalhes do usuário via SP_MASTER_DISPATCHER
            const spUserResult = await executeSPMaster("AUTH", "USER.GET_DETAILS", null, { p_login: userLogin });

            if (!spUserResult.sucesso || !spUserResult.resultado || !spUserResult.resultado.user) {
                // Registrar tentativa de login falha se usuário não encontrado pela SP
                await executeSPMaster("AUTH", "LOG_LOGIN_ATTEMPT", null, {
                    p_id_usuario: null,
                    p_id_entidade: null,
                    p_login: userLogin,
                    p_ip_origem: ip,
                    p_user_agent: userAgent.substring(0, 100),
                    p_sucesso: 0,
                    p_metadata: JSON.stringify({ motivo: 'usuario_nao_encontrado_sp' })
                });
                return res.json({ sucesso: false, erro: "USUARIO_NAO_ENCONTRADO", mensagem: "Usuário não encontrado" });
            }

            const user = spUserResult.resultado.user; // Agora contendo id_pessoa
            if (user.ativo !== 1) {
                await executeSPMaster("AUTH", "LOG_LOGIN_ATTEMPT", null, {
                    p_id_usuario: user.id_usuario, p_id_entidade: user.id_entidade, p_login: userLogin, p_ip_origem: ip, p_user_agent: userAgent.substring(0, 100), p_sucesso: 0, p_metadata: JSON.stringify({ motivo: 'usuario_inativo' })
                });
                return res.json({ sucesso: false, erro: "USUARIO_INATIVO", mensagem: "Usuário inativo" });
            }
            const senhaValida = await bcrypt.compare(senha, user.senha_hash);

            // Fallback para SHA256 e texto plano (compatibilidade com usuários legados como evandro.andrade)
            let loginValido = senhaValida;
            if (!loginValido && user.senha_hash) {
                const sha256 = crypto.createHash("sha256").update(senha).digest("hex");
                if (user.senha_hash.toLowerCase() === sha256.toLowerCase()) {
                    loginValido = true;
                } else if (user.senha_hash === senha) { // Texto plano (apenas para desenvolvimento/usuários específicos)
                    loginValido = true;
                }
            }

            if (!loginValido) {
                await executeSPMaster("AUTH", "LOG_LOGIN_ATTEMPT", null, {
                    p_id_usuario: user.id_usuario,
                    p_id_entidade: user.id_entidade,
                    p_login: userLogin, p_ip_origem: ip,
                    p_user_agent: userAgent.substring(0, 100),
                    p_sucesso: 0, p_metadata: JSON_OBJECT('motivo', 'senha_invalida')
                });
                return res.json({ sucesso: false, erro: "SENHA_INVALIDA", mensagem: "Senha incorreta" });
            }

            // 2. Criar Tokens Primeiro (precisamos do token_jwt para a sessão)
            const jwtToken = jwt.sign({ 
                id_usuario: user.id_usuario, 
                id_pessoa: user.id_pessoa, // Injeção da Entidade Real
                id_sessao_usuario: 0, // Será atualizado após criar sessão
                login: user.login,
                id_entidade: user.id_entidade
            }, SECRET, { expiresIn: EXPIRES_IN });

            const refreshToken = jwt.sign({
                id_usuario: user.id_usuario, 
                id_pessoa: user.id_pessoa,
                id_sessao_usuario: 0,
                login: user.login,
                id_entidade: user.id_entidade,
                tipo: 'refresh'
            }, SECRET, { expiresIn: '7d' });

            // Criar sessão e registrar tentativa de login bem-sucedida via SP_MASTER_DISPATCHER
            const spCreateSessionResult = await executeSPMaster("AUTH", "SESSION.CREATE", null, {
                p_id_usuario: user.id_usuario,
                p_id_pessoa: user.id_pessoa, // Passa id_pessoa para a SP
                p_id_entidade: user.id_entidade, // Passa id_entidade para a SP
                p_jwt_token: jwtToken, // Passa o JWT inicial para a SP
                p_refresh_token: refreshToken, // Passa o Refresh Token inicial para a SP
                p_ip_origem: ip,
                p_user_agent: userAgent.substring(0, 255),
                p_login: userLogin, // Passa o login para fins de log na SP
                p_sucesso: 1,
                p_metadata: JSON_OBJECT('status', 'sucesso')
            });

            if (!spCreateSessionResult.sucesso || !spCreateSessionResult.resultado || !spCreateSessionResult.resultado.id_sessao_usuario) {
                console.error("Erro ao criar sessão via SP:", spCreateSessionResult.mensagem);
                return res.status(500).json({ sucesso: false, erro: "ERRO_AO_CRIAR_SESSAO", mensagem: spCreateSessionResult.mensagem });
            }

            const { id_sessao_usuario } = spCreateSessionResult.resultado;

            // Gerar Token Final com ID da Sessão persistida
            const jwtTokenFinal = jwt.sign({ 
                id_usuario: user.id_usuario, 
                id_pessoa: user.id_pessoa,
                id_sessao_usuario: id_sessao_usuario,
                login: user.login,
                id_entidade: user.id_entidade
            }, SECRET, { expiresIn: EXPIRES_IN });

            const refreshTokenFinal = jwt.sign({ 
                id_usuario: user.id_usuario, 
                id_pessoa: user.id_pessoa,
                id_sessao_usuario: id_sessao_usuario,
                login: user.login,
                id_entidade: user.id_entidade,
                tipo: 'refresh'
            }, SECRET, { expiresIn: '7d' });

            // Atualizar sessão com os tokens finais via SP_MASTER_DISPATCHER
            await executeSPMaster("AUTH", "SESSION.UPDATE_TOKENS", null, {
                p_id_sessao_usuario: id_sessao_usuario,
                p_jwt_token: jwtTokenFinal,
                p_refresh_token: refreshTokenFinal
            });

            // Buscar dados da entidade para branding white-label
            let entidadeData = null;
            try {
                const spEntidadeResult = await executeSPMaster("AUTH", "ENTIDADE.GET_DETAILS", null, { p_id_entidade: user.id_entidade });
                if (spEntidadeResult.sucesso && spEntidadeResult.resultado && spEntidadeResult.resultado.entidade) {
                    entidadeData = spEntidadeResult.resultado.entidade;
                } else {
                    console.warn("Erro ou entidade não encontrada via SP:", spEntidadeResult.mensagem);
                }
                } catch (entErr) {
                console.warn("Erro ao buscar entidade:", entErr.message);
            }

            // 4. Buscar Sistemas/Aplicações autorizadas para o Portal
            const spSistemasResult = await executeSPMaster("AUTH", "USER.GET_SISTEMAS", null, {
                p_id_usuario: user.id_usuario 
            });
            
            const sistemasAutorizados = spSistemasResult.sucesso ? 
                spSistemasResult.resultado.sistemas : [];

// Definir refresh token como HttpOnly Cookie
             res.cookie('refreshToken', refreshTokenFinal, {
               httpOnly: true,
               secure: process.env.NODE_ENV === 'production',
               sameSite: 'strict',
               maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
             });

             return res.json({ 
                 sucesso: true, 
                 sessao: { 
                     id_sessao_usuario, 
                     id_usuario: user.id_usuario,
                     contexto_definido: false // Obriga a passar pelo Modal de Contexto na App
                 }, 
                 usuario: { id_usuario: user.id_usuario, id_pessoa: user.id_pessoa, login: user.login, nome: user.nome_pessoa }, // Adiciona nome da pessoa
                 entidade: entidadeData,
                 sistemas: sistemasAutorizados, // Lista para o Portal Corporativo
                 token: jwtTokenFinal
             });

        } catch (err) {
            console.error("Erro no fluxo de login:", err);
            // Registrar tentativa de login falha se ocorrer um erro inesperado
            await executeSPMaster("AUTH", "LOG_LOGIN_ATTEMPT", null, {
                p_id_usuario: null, p_id_entidade: null, p_login: userLogin, p_ip_origem: ip, p_user_agent: userAgent.substring(0, 100), p_sucesso: 0, p_metadata: JSON_OBJECT('motivo', 'erro_interno_sp', 'details', err.message)
            });
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message }); // Retorna o erro original para o frontend
        } finally {
            if (conn) conn.release(); // Garante que a conexão seja liberada
        }
    }

    // Refatorado para usar SP_MASTER_DISPATCHER
    static async listarContextos(req, res) { // Usado pelo ContextSelectionModal
        const id_sessao = req.user?.id_sessao_usuario;
        if (!id_sessao) return res.status(401).json({ sucesso: false, erro: "SESSAO_NAO_ENCONTRADA" });

        try {
            // Delega a lógica de listagem de contextos para a SP_MASTER_DISPATCHER
            const spResult = await executeSPMaster("AUTH", "CONTEXTO.LIST_AVAILABLE", id_sessao, {
                p_id_usuario: req.user.id_usuario,
                p_login: req.user.login // Para bypass de evandro.andrade na SP
            });

            if (spResult.sucesso && spResult.resultado) {
                return res.json({ sucesso: true, ...spResult.resultado });
            } else {
                return res.json({ sucesso: false, mensagem: spResult.mensagem || "Erro ao listar contextos." });
            }
        } catch (err) {
            console.error("Erro no dispatcher listarContextos:", err.message);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
        }
    }

    /**
     * Portal Dispatcher - Entrada Única para o Módulo Portal
     * Respeita a Ordem Ontológica: Sessão -> Ação -> SP
     */
    static async portalDispatcher(req, res) {
        const { acao, payload } = req.body;
        const id_sessao = req.user?.id_sessao_usuario;
        const id_usuario = req.user?.id_usuario;

        if (!id_sessao) return res.status(401).json({ sucesso: false, erro: "SESSAO_EXIGIDA" });

        try {
            // Injeta o contexto de segurança no payload antes de enviar para a SP
            const fullPayload = {
                ...payload,
                p_id_usuario: id_usuario,
                p_id_saas_entidade: req.user?.id_entidade
            };

            const resultado = await executeSPMaster("PORTAL", acao, id_sessao, fullPayload);
            return res.json(resultado);
        } catch (err) {
            return res.status(500).json({ sucesso: false, erro: "ERRO_DISPATCHER_PORTAL", mensagem: err.message });
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
                    id_pessoa: req.user?.id_pessoa,
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
            // sp_auth_menu_get(p_id_sessao, OUT p_resultado, OUT p_sucesso, OUT p_mensagem)
            const sql = `CALL sp_auth_menu_get(?, @p_resultado, @p_sucesso, @p_mensagem);
                         SELECT @p_resultado AS resultado, @p_sucesso AS sucesso, @p_mensagem AS mensagem;`;
            const [rows] = await pool.query(sql, [id_sessao]);
            const out = rows?.[1]?.[0] || {};

            const sucesso = out.sucesso === 1 || out.sucesso === true || out.sucesso === '1';
            const resultado = out.resultado ? JSON.parse(out.resultado) : {};

            return res.json({ sucesso, resultado, mensagem: out.mensagem });
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
        const token = req.cookies?.refreshToken;
        if (!token) return res.json({ sucesso: false, erro: "REFRESH_TOKEN_OBRIGATORIO" });
        try {
            const decoded = jwt.verify(token, SECRET);
            let conn;
            try {
                conn = await pool.getConnection();
                const [rows] = await conn.execute(
                    "SELECT id_sessao_usuario, id_usuario, ativo, expira_em, id_unidade, id_local, id_perfil, id_sala FROM sessao_usuario WHERE id_sessao_usuario = ?",
                    [decoded.id_sessao_usuario]
                );
                if (!rows.length || rows[0].ativo !== 1) return res.json({ sucesso: false, erro: "SESSAO_INATIVA" });
                const sessao = rows[0];
                const newToken = jwt.sign({ 
                    id_usuario: decoded.id_usuario, 
                    id_pessoa: decoded.id_pessoa,
                    id_sessao_usuario: decoded.id_sessao_usuario,
                    login: decoded.login,
                    id_unidade: sessao.id_unidade,
                    id_local_operacional: sessao.id_local,
                    id_perfil: sessao.id_perfil
                }, SECRET, { expiresIn: EXPIRES_IN });
                return res.json({
                    sucesso: true,
                    token: newToken,
                    id_sessao_usuario: decoded.id_sessao_usuario,
                    sessao: {
                        id_sessao: decoded.id_sessao_usuario,
                        id_sessao_usuario: decoded.id_sessao_usuario,
                        id_usuario: sessao.id_usuario || decoded.id_usuario,
                        id_unidade: sessao.id_unidade,
                        id_local: sessao.id_local,
                        id_sala: sessao.id_sala,
                        id_perfil: sessao.id_perfil,
                        contexto_definido: Boolean(sessao.id_perfil && sessao.id_unidade)
                    }
                });
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
            
            // Delega a lógica de listagem de contextos para a SP_MASTER_DISPATCHER
            const spResult = await executeSPMaster("AUTH", "CONTEXTO.LIST_USER_CONTEXTS", id_sessao, {
                p_id_usuario: req.user.id_usuario,
                p_login: req.user.login // Para bypass de evandro.andrade na SP
            });

            if (spResult.sucesso && spResult.resultado) {
                return res.json({ sucesso: true, ...spResult.resultado });
            } else {
                return res.json({ sucesso: false, mensagem: spResult.mensagem || "Erro ao listar meus contextos." });
            }
        } catch (err) {
            console.error("Erro meusContextosSP:", err.message);
            return res.status(500).json({ sucesso: false, erro: "ERRO_INTERNO", mensagem: err.message });
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
