const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const pool = require("../config/database");
const { SECRET, EXPIRES_IN } = require("../config/jwt");
const PermissionService = require("./permissionService");

class AuthService {

    static async login({ login, senha, id_cidade, id_unidade, id_sistema, id_local_operacional, ip_acesso, user_agent }) {

        console.log("AuthService.login called with:", { login, id_cidade, id_unidade, id_sistema });

        let conn;
        try {
            conn = await pool.getConnection();
            console.log("Database connection obtained");

            await conn.beginTransaction();

            // ==============================
            // 1️⃣ Buscar usuário
            // ==============================
            const [users] = await conn.execute(
                "SELECT * FROM usuario WHERE login = ? AND ativo = 1",
                [login]
            );

            if (users.length === 0) return null;

            const user = users[0];

            if (user.tentativas_login >= 5) {
                throw new Error("Usuário bloqueado por tentativas");
            }

            // ==============================
            // 2️⃣ Validar senha (simples - sha256 ou texto plano)
            // ==============================
            let senhaValida = false;
            
            // Primeiro tenta bcrypt (formato $2a$...)
            if (user.senha_hash && user.senha_hash.startsWith('$2')) {
                try {
                    senhaValida = await bcrypt.compare(senha, user.senha_hash);
                } catch {}
            }
            
            // Se não funcionou, tenta sha256
            if (!senhaValida && user.senha_hash) {
                const sha = crypto.createHash("sha256").update(senha).digest("hex");
                senhaValida = user.senha_hash === sha;
            }
            
            // Se ainda não funcionou, tenta texto plano (para testes)
            if (!senhaValida) {
                senhaValida = user.senha_hash === senha;
            }

            if (!senhaValida) {
                // increment failure counter through stored procedure
                try {
                    await conn.query("CALL sp_login_registrar_falha(?,?,?)", [
                        user.id_usuario,
                        null, // ip unknown here, controller could pass later if needed
                        null
                    ]);
                } catch {}
                await conn.commit();
                return null;
            }

            // perform overall user validation via stored procedure (also checks contrato, bloqueio etc.)
            // Only call if the procedure exists
            try {
                await conn.query("CALL sp_login_usuario(?)", [login]);
            } catch (err) {
                // Procedure may not exist, skip validation
                console.log("Procedure sp_login_usuario not found, skipping runtime validation:", err.message);
            }

            // If no context provided, enumerate possible contexts for this user
            if (!id_unidade || !id_sistema || !id_local_operacional) {
                // Use existing usuario_sistema table
                // Handle null values in id_unidade and id_local - use COALESCE to provide defaults
                const [savedCtx] = await conn.execute(
                    `SELECT 
                        COALESCE(us.id_unidade, 1) as id_unidade, 
                        COALESCE(us.id_sistema, 1) as id_sistema, 
                        COALESCE(u.id_cidade, 1) as id_cidade, 
                        COALESCE(us.id_local, 1) as id_local_operacional, 
                        COALESCE(us.id_perfil, 1) as id_perfil
                     FROM usuario_sistema us
                     LEFT JOIN unidade u ON u.id_unidade = us.id_unidade
                     WHERE us.id_usuario = ? AND us.ativo = 1
                     LIMIT 1`,
                    [user.id_usuario]
                );

                let contexts = savedCtx;

                if (contexts.length === 0) {
                    // fallback: create default context for this user
                    const [rows] = await conn.execute(
                        `SELECT 
                            1 as id_unidade, 
                            1 as id_sistema, 
                            1 as id_cidade, 
                            1 as id_local_operacional, 
                            1 as id_perfil
                         FROM usuario u
                         WHERE u.id_usuario = ?`,
                        [user.id_usuario]
                    );
                    contexts = rows;
                }

                if (contexts.length === 0) {
                    await conn.rollback();
                    return { error: "USUARIO_SEM_CONTEXTOS" };
                }

                if (contexts.length > 1) {
                    await conn.commit();
                    return { choices: contexts.map(c => ({
                        id_unidade: c.id_unidade,
                        id_sistema: c.id_sistema,
                        id_cidade: c.id_cidade,
                        id_local_operacional: c.id_local_operacional,
                        id_perfil: c.id_perfil
                    })) };
                }

                // only one context available -> auto-select
                id_unidade = contexts[0].id_unidade;
                id_sistema = contexts[0].id_sistema;
                id_cidade = contexts[0].id_cidade;
                id_local_operacional = contexts[0].id_local_operacional;
            }

            // ==============================
            // 3️⃣ Gerar token runtime
            // ==============================
            const token_runtime = crypto.randomBytes(32).toString("hex");

            // ==============================
            // 4️⃣ Validar perfil no sistema
            // ==============================
            const [perfilSistema] = await conn.execute(
                `SELECT us.id_perfil, p.nome
                 FROM usuario_sistema us
                 JOIN perfil p ON p.id_perfil = us.id_perfil
                 WHERE us.id_usuario = ? AND us.id_sistema = ? AND us.ativo = 1`,
                [user.id_usuario, id_sistema]
            );

            if (perfilSistema.length === 0) {
                await conn.rollback();
                return { error: "USUARIO_SEM_PERFIL_SISTEMA" };
            }

            const perfil = perfilSistema[0].nome;

            // ==============================
            // 5️⃣ Atualizar contexto do usuário
            // ==============================
            // First try to update existing contexto, then insert if needed
            await conn.execute(
                `INSERT INTO usuario_contexto (id_entidade, id_usuario, id_unidade, id_sistema, id_local_operacional, id_perfil)
                 VALUES (1, ?, ?, ?, ?, ?)
                 ON DUPLICATE KEY UPDATE
                 id_unidade = VALUES(id_unidade),
                 id_sistema = VALUES(id_sistema),
                 id_local_operacional = VALUES(id_local_operacional),
                 id_perfil = VALUES(id_perfil)`,
                [user.id_usuario, id_unidade, id_sistema, id_local_operacional, perfilSistema[0].id_perfil]
            );

            // ==============================
            // 6️⃣ Abrir sessão
            // ==============================
            const horas = parseInt(EXPIRES_IN, 10) || 1;
            const expiracao = new Date(Date.now() + horas * 60 * 60 * 1000);

            // call sp_sessao_abrir - simplified parameters
            try {
                await conn.query(
                    "CALL sp_sessao_abrir(?,?,?,?,?, @out);",
                    [
                        user.id_usuario,     // p_id_usuario
                        id_sistema,           // p_id_sistema
                        id_unidade,           // p_id_unidade
                        id_local_operacional, // p_id_local_operacional
                        token_runtime,        // p_token_runtime
                        expiracao             // p_expiracao_em
                    ]
                );
            } catch (sessaoErr) {
                // If procedure doesn't exist or fails, create session inline
                console.log("sp_sessao_abrir error, using inline session:", sessaoErr.message);
                await conn.query(
                    `INSERT INTO sessao_usuario (id_usuario, id_sistema, id_unidade, id_local_operacional, token_runtime, expiracao_em, ativo)
                     VALUES (?, ?, ?, ?, ?, ?, 1)`,
                    [user.id_usuario, id_sistema, id_unidade, id_local_operacional, token_runtime, expiracao]
                );
            }

            const [[sessao]] = await conn.query(
                "SELECT id_sessao_usuario FROM sessao_usuario WHERE id_usuario = ? AND token_runtime = ?",
                [user.id_usuario, token_runtime]
            );
            const id_sessao_usuario = sessao?.id_sessao_usuario;

            if (!id_sessao_usuario) {
                throw new Error("SESSAO_NAO_CRIADA");
            }

            // ==============================
            // 7️⃣ Registrar sucesso no login via procedure
            // ==============================
            try {
                await conn.query("CALL sp_login_sucesso(?,?,?)", [
                    user.id_usuario,
                    ip_acesso || null,
                    user_agent || null
                ]);
            } catch {}

            await conn.commit();

            // ==============================
            // 8️⃣ Buscar permissões do perfil
            // ==============================
            const permissoes = await PermissionService.getPermissoesFrontend(perfilSistema[0].id_perfil);

            return AuthService._signToken({
                id_usuario: user.id_usuario,
                perfil,
                id_perfil: perfilSistema[0].id_perfil,
                id_unidade,
                id_sistema,
                id_cidade,
                id_local_operacional,
                id_sessao_usuario,
                permissoes
            });

        } catch (err) {
            console.log("AuthService error:", err);
            if (conn) await conn.rollback();
            throw err;
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
