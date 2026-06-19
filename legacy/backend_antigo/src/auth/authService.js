const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const pool = require("../config/database");
const { SECRET, EXPIRES_IN } = require("../config/jwt");
const PermissionService = require("./permissionService");

class AuthService {
    static _normalizeHash(value) {
        return String(value || "").trim().toLowerCase();
    }

    /**
     * Login usando stored procedure sp_auth_login
     * O sistema inteiro é baseado em procedures
     */
    static async login({ login, senha, id_cidade, id_unidade, id_sistema, id_local_operacional, ip_acesso, user_agent }) {

        console.log("AuthService.login (via SP):", { login, id_sistema, id_unidade, id_local_operacional });

        let conn;
        try {
            conn = await pool.getConnection();

            // ==============================
            // 1️⃣ Chamada à SP de login
            // ==============================
            // sp_auth_login(
            //   p_login,
            //   p_senha,
            //   p_id_sistema,
            //   p_id_unidade,
            //   p_id_local_operacional,
            //   p_id_dispositivo,
            //   p_ip_origem,
            //   p_user_agent
            // )
            
            // Primeiro busca o usuário para validar senha via código
            const [users] = await conn.execute(
                "SELECT * FROM usuario WHERE login = ? AND ativo = 1",
                [login]
            );

            if (users.length === 0) {
                throw new Error("USUARIO_NAO_ENCONTRADO");
            }

            const user = users[0];

            // Valida senha (bcrypt, sha256 ou texto plano legado)
            let senhaValida = false;
            const senhaTexto = String(senha ?? "");
            const shaCalculada = AuthService._normalizeHash(
                crypto.createHash("sha256").update(senhaTexto).digest("hex")
            );
            const hashBanco = AuthService._normalizeHash(user.senha_hash);
            console.log("DEBUG - Senha recebida:", senha);
            console.log("DEBUG - SHA256 calculada:", shaCalculada);
            console.log("DEBUG - Hash no banco:", user.senha_hash);
            console.log("DEBUG - bcrypt?", user.senha_hash?.startsWith('$2'));
            
            if (user.senha_hash && user.senha_hash.startsWith('$2')) {
                try {
                    const bcrypt = require("bcryptjs");
                    senhaValida = await bcrypt.compare(senha, user.senha_hash);
                    console.log("DEBUG - bcrypt result:", senhaValida);
                } catch {}
            }
            
            if (!senhaValida && hashBanco) {
                senhaValida = hashBanco === shaCalculada;
                console.log("DEBUG - SHA256 match:", senhaValida);
            }
            
            if (!senhaValida) {
                senhaValida = user.senha_hash === senhaTexto;
                console.log("DEBUG - texto plano match:", senhaValida);
            }

            if (!senhaValida) {
                throw new Error("SENHA_INVALIDA");
            }

            // Resolve contexto operacional do usuário para:
            // 1) retornar choices quando houver múltiplos contextos
            // 2) validar contexto selecionado no segundo passo do login
            let contextRows = [];
            try {
                const [rows] = await conn.execute(
                    `SELECT 
                        uc.id_sistema,
                        uc.id_unidade,
                        uc.id_local_operacional,
                        uc.id_perfil
                     FROM usuario_contexto uc
                     WHERE uc.id_usuario = ? AND uc.ativo = 1`,
                    [user.id_usuario]
                );
                contextRows = rows || [];
            } catch {}

            // Fallback para schema legado
            // ATENCAO: a tabela usuario_sistema do dump original NAO tem id_unidade nem id_local_operacional
            if (!contextRows.length) {
                try {
                    const [rows] = await conn.execute(
                        `SELECT 
                            us.id_sistema,
                            1 AS id_unidade,
                            1 AS id_local_operacional,
                            us.id_perfil
                         FROM usuario_sistema us
                         WHERE us.id_usuario = ? AND us.ativo = 1`,
                        [user.id_usuario]
                    );
                    contextRows = rows || [];
                } catch (ctxErr) {
                    console.log("Erro ao buscar usuario_sistema:", ctxErr.message);
                }
            }

            // Se ainda nao tem contexto, usa valores padrao do sistema
            if (!contextRows.length) {
                console.log("Criando contexto padrao para o usuario...");
                // Usa valores padrao hardcoded para evitar erro
                contextRows = [{ id_sistema: 1, id_unidade: 1, id_local_operacional: 1, id_perfil: 1 }];
            }

            const hasContextSelected =
                id_sistema !== undefined &&
                id_unidade !== undefined &&
                id_local_operacional !== undefined;

            let selectedContext = null;

            if (!hasContextSelected) {
                if (contextRows.length > 1) {
                    return {
                        choices: contextRows.map((ctx) => ({
                            id_sistema: ctx.id_sistema,
                            id_unidade: ctx.id_unidade,
                            id_local_operacional: ctx.id_local_operacional,
                            id_perfil: ctx.id_perfil
                        }))
                    };
                }
                selectedContext = contextRows[0];
            } else {
                selectedContext = contextRows.find((ctx) =>
                    String(ctx.id_sistema) === String(id_sistema) &&
                    String(ctx.id_unidade) === String(id_unidade) &&
                    String(ctx.id_local_operacional) === String(id_local_operacional)
                );

                if (!selectedContext) {
                    return { error: "CONTEXTO_INVALIDO" };
                }
            }

            id_sistema = selectedContext.id_sistema;
            id_unidade = selectedContext.id_unidade;
            id_local_operacional = selectedContext.id_local_operacional;
            let id_perfil = selectedContext.id_perfil || 1;

            // ==============================
            // 2️⃣ Chama SP original do dump para criar sessão
            // ==============================
            // sp_auth_criar_sessao(p_id_usuario, p_id_sistema, p_id_unidade, p_id_local, p_id_perfil, p_token)
            // Esta SP NÃO valida senha - a validação já foi feita no JavaScript acima
            let loginResult;
            try {
                // Gera um token aleatório para a sessão
                const tokenJwt = require('crypto').randomBytes(32).toString('hex');
                // Busca entidade do usuário (multi-tenant obrigatório)
                const [[uEnt]] = await conn.query(
                    "SELECT id_entidade FROM usuario WHERE id_usuario = ?",
                    [user.id_usuario]
                );
                const id_entidade = uEnt?.id_entidade || null;
                
                [loginResult] = await conn.query(
                    "CALL sp_auth_criar_sessao(?, ?, ?, ?, ?, ?)",
                    [
                        user.id_usuario,
                        id_sistema,
                        id_unidade,
                        id_local_operacional,
                        id_perfil,
                        tokenJwt
                    ]
                );
            } catch (spErr) {
                console.log("sp_auth_criar_sessao error:", spErr.message);
                // Fallback: criar sessão manualmente
                // Usa token_jwt porque token_runtime pode não existir
                const tokenJwt = require('crypto').randomBytes(32).toString('hex');
                const expira = new Date(Date.now() + 8 * 60 * 60 * 1000); // 8 horas
                const [[uEnt]] = await conn.query(
                    "SELECT id_entidade FROM usuario WHERE id_usuario = ?",
                    [user.id_usuario]
                );
                const id_entidade = uEnt?.id_entidade || null;
                
                await conn.query(
                    `INSERT INTO sessao_usuario 
                     (id_usuario, id_entidade, id_sistema, id_unidade, id_local, id_perfil, token_jwt, iniciado_em, expira_em, ativo)
                     VALUES (?, ?, ?, ?, ?, ?, ?, NOW(6), ?, 1)`,
                    [user.id_usuario, id_entidade, id_sistema, id_unidade, id_local_operacional, id_perfil, tokenJwt, expira]
                );
            }

            // A SP retorna os dados da sessão na primeira posição
            let sessao = loginResult?.[0]?.[0] || loginResult?.[0] || null;

            // Fallback: busca sessão recém-criada
            // ATENCAO: token_runtime pode nao existir no banco original (usa token_jwt)
            if (!sessao || !sessao.id_sessao_usuario) {
                try {
                    const [sessaoRows] = await conn.query(
                        `SELECT 
                            su.id_sessao_usuario,
                            su.id_usuario,
                            su.id_sistema,
                            su.id_unidade,
                            su.id_local_operacional,
                            su.token_jwt AS token_jwt,
                            su.expira_em AS expiracao_em
                         FROM sessao_usuario su
                         WHERE su.id_usuario = ? AND su.ativo = 1
                         ORDER BY su.id_sessao_usuario DESC
                         LIMIT 1`,
                        [user.id_usuario]
                    );
                    sessao = sessaoRows?.[0] || sessao;
                } catch (sessaoErr) {
                    console.log("Erro ao buscar sessao:", sessaoErr.message);
                }
            }

            // Usa token_jwt como token_runtime para compatibilidade
            const token_runtime = sessao?.token_jwt || sessao?.token_runtime;

            if (!sessao) {
                throw new Error("ERRO_AO_CRIAR_SESSAO");
            }

            const { 
                id_sessao_usuario, 
                id_usuario: sessaoIdUsuario,
                id_sistema: sessaoIdSistema,
                id_unidade: sessaoIdUnidade,
                id_local_operacional: sessaoIdLocal,
                token_jwt,
                expiracao_em
            } = sessao;

            // ==============================
            // 3️⃣ Busca perfil do usuário
            // ==============================
            let perfil = "ADMINISTRADOR";
            
            try {
                const [perfilRow] = await conn.execute(
                    `SELECT us.id_perfil, p.nome
                     FROM usuario_sistema us
                     JOIN perfil p ON p.id_perfil = us.id_perfil
                     WHERE us.id_usuario = ? AND us.id_sistema = ? AND us.ativo = 1`,
                    [user.id_usuario, id_sistema]
                );

                if (perfilRow.length > 0) {
                    perfil = perfilRow[0].nome;
                    id_perfil = perfilRow[0].id_perfil;
                }
            } catch (perfilErr) {
                console.log("Error getting perfil:", perfilErr.message);
                // Usa valores padrão
            }

            // ==============================
            // 4️⃣ Chama SP para buscar permissões
            // ==============================
            let permissoes = [];
            try {
                const [permResult] = await conn.query(
                    "CALL sp_auth_permissoes(?)",
                    [token_runtime]
                );
                permissoes = permResult[0] || [];
            } catch (permErr) {
                console.log("sp_auth_permissoes error:", permErr.message);
                // Fallback para PermissionService
                permissoes = await PermissionService.getPermissoesFrontend(id_perfil);
            }

            // ==============================
            // 5️⃣ Retorna JWT com dados da sessão
            // ==============================
            const token = AuthService._signToken({
                id_usuario: user.id_usuario,
                perfil,
                id_perfil,
                id_unidade: sessaoIdUnidade || id_unidade,
                id_sistema: sessaoIdSistema || id_sistema,
                id_cidade: id_cidade || 1,
                id_local_operacional: sessaoIdLocal || id_local_operacional,
                id_sessao_usuario,
                permissoes
            });
            return { token };

        } catch (err) {
            console.log("AuthService error:", err.message);
            console.log("AuthService stack:", err.stack);
            
            const errorMessage = err.message || '';
            
            if (errorMessage.includes('USUARIO_NAO_ENCONTRADO')) {
                throw new Error('USUARIO_NAO_ENCONTRADO');
            }
            if (errorMessage.includes('SENHA')) {
                throw new Error('SENHA_INCORRETA');
            }
            if (errorMessage.includes('bloqueado')) {
                throw new Error('USUARIO_BLOQUEADO');
            }
            
            // Erro genérico - mostrar mensagem real
            throw new Error('ERRO_AO_FAZER_LOGIN: ' + errorMessage);
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Valida sessão usando sp_auth_validar_sessao
     */
    static async validarSessao(token_runtime) {
        console.log("AuthService.validarSessao:", token_runtime);

        let conn;
        try {
            conn = await pool.getConnection();

            const [result] = await conn.query(
                "CALL sp_auth_validar_sessao(?)",
                [token_runtime]
            );

            const sessao = result[0]?.[0];
            
            if (!sessao) {
                return null;
            }

            return {
                id_sessao_usuario: sessao.id_sessao_usuario,
                id_usuario: sessao.id_usuario,
                id_sistema: sessao.id_sistema,
                id_unidade: sessao.id_unidade,
                id_local_operacional: sessao.id_local_operacional
            };

        } catch (err) {
            console.log("validarSessao error:", err.message);
            return null;
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Logout - encerra sessão
     */
    static async logout(id_sessao_usuario) {
        let conn;
        try {
            conn = await pool.getConnection();
            
            await conn.query(
                "CALL sp_auth_logout(?)",
                [id_sessao_usuario]
            );

            return true;
        } catch (err) {
            console.log("logout error:", err.message);
            // Tenta método alternativo
            try {
                await conn.query(
                    "UPDATE sessao_usuario SET ativo = 0, finalized_em = NOW() WHERE id_sessao_usuario = ?",
                    [id_sessao_usuario]
                );
                return true;
            } catch {}
            return false;
        } finally {
            if (conn) conn.release();
        }
    }

    static _signToken(payload) {
        return jwt.sign(payload, SECRET, {
            expiresIn: EXPIRES_IN
        });
    }
}

module.exports = AuthService;
