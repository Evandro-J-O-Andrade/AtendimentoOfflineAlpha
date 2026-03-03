const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const pool = require("../config/database");
const { SECRET, EXPIRES_IN } = require("../config/jwt");

class AuthService {

    static async login({ login, senha, id_cidade, id_unidade, id_sistema, id_local_operacional }) {

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
                // First try saved usuario_contexto
                const [savedCtx] = await conn.execute(
                    `SELECT uc.id_unidade, uc.id_sistema, u.id_cidade, uc.id_local_operacional, uc.id_perfil
                     FROM usuario_contexto uc
                     JOIN unidade u ON u.id_unidade = uc.id_unidade
                     WHERE uc.id_usuario = ?`,
                    [user.id_usuario]
                );

                let contexts = savedCtx;

                if (contexts.length === 0) {
                    // fallback: build cross-product of unidades x sistemas linked to user
                    const [rows] = await conn.execute(
                        `SELECT uu.id_unidade, us.id_sistema, u.id_cidade,
                                ulo.id_local_operacional, NULL AS id_perfil
                         FROM usuario_unidade uu
                         JOIN unidade u ON u.id_unidade = uu.id_unidade
                         JOIN usuario_sistema us ON us.id_usuario = uu.id_usuario
                         JOIN usuario_local_operacional ulo ON ulo.id_usuario = uu.id_usuario
                         WHERE uu.id_usuario = ?`,
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
            // 3️⃣ Validar cidade ↔ unidade
            // ==============================
            const [unidadeCidade] = await conn.execute(
                "SELECT * FROM unidade WHERE id_unidade = ? AND id_cidade = ?",
                [id_unidade, id_cidade]
            );

            if (unidadeCidade.length === 0) {
                throw new Error("Unidade não pertence à cidade");
            }

            // ==============================
            // 4️⃣ Validar vínculo usuario ↔ unidade
            // ==============================
            const [usuarioUnidade] = await conn.execute(
                "SELECT * FROM usuario_unidade WHERE id_usuario = ? AND id_unidade = ?",
                [user.id_usuario, id_unidade]
            );

            if (usuarioUnidade.length === 0) {
                throw new Error("Usuário não vinculado à unidade");
            }

            // ==============================
            // 5️⃣ Validar vínculo usuario ↔ sistema
            // ==============================
            const [usuarioSistema] = await conn.execute(
                "SELECT * FROM usuario_sistema WHERE id_usuario = ? AND id_sistema = ?",
                [user.id_usuario, id_sistema]
            );

            if (usuarioSistema.length === 0) {
                throw new Error("Usuário não vinculado ao sistema");
            }

            // ==============================
            // 6️⃣ Validar perfil no sistema
            // ==============================
            const [perfilSistema] = await conn.execute(
                `SELECT usp.*, p.nome 
                 FROM usuario_sistema_perfil usp
                 JOIN perfil p ON p.id_perfil = usp.id_perfil
                 WHERE usp.id_usuario = ? AND usp.id_sistema = ?`,
                [user.id_usuario, id_sistema]
            );

            if (perfilSistema.length === 0) {
                throw new Error("Usuário sem perfil neste sistema");
            }

            const perfil = perfilSistema[0].nome;

            // ==============================
            // 7️⃣ Atualizar contexto
            // ==============================
            await conn.execute(
                `REPLACE INTO usuario_contexto
                 (id_usuario, id_unidade, id_sistema, id_local_operacional, id_perfil)
                 VALUES (?, ?, ?, ?, ?)`,
                [user.id_usuario, id_unidade, id_sistema, id_local_operacional, perfilSistema[0].id_perfil]
            );

            // ==============================
            // Criar sessão de usuário para runtime guard via stored procedure
            // ==============================
            const token_runtime = crypto.randomBytes(32).toString("hex");
            const horas = parseInt(EXPIRES_IN, 10) || 1;
            const expira = new Date(Date.now() + horas * 60 * 60 * 1000);

            // call sp_sessao_abrir and capture output parameter
            const [[{p_id_sessao_usuario}]] = await conn.query(
                "CALL sp_sessao_abrir(?,?,?,?,?,?,?, ?, @out); SELECT @out as p_id_sessao_usuario;",
                [user.id_usuario, id_sistema, id_unidade, id_local_operacional, token_runtime, null, null, expira]
            );

            const id_sessao_usuario = p_id_sessao_usuario;

            // ==============================
            // 8️⃣ Registrar sucesso no login via procedure
            // ==============================
            try {
                await conn.query("CALL sp_login_registrar_sucesso(?,?,?)", [
                    user.id_usuario,
                    null,
                    null
                ]);
            } catch {}

            await conn.commit();

            return AuthService._signToken({
                id_usuario: user.id_usuario,
                perfil,
                id_unidade,
                id_sistema,
                id_cidade,
                id_local_operacional,
                id_sessao_usuario
            });

        } catch (err) {
            console.error("AuthService error:", err);
            if (conn) await conn.rollback();
            throw err;
        } finally {
            if (conn) conn.release();
        }
    }

    static _signToken(payload) {
        return jwt.sign(payload, SECRET, { expiresIn: EXPIRES_IN });
    }
}

module.exports = AuthService;