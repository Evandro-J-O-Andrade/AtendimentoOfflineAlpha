const jwt = require("jsonwebtoken");
const pool = require("../config/database"); // ajuste conforme sua infra
const { SECRET } = require("../config/jwt");

/*
=====================================
Guardião Runtime Assistencial Hardened
=====================================
*/

module.exports = async function guardiaoRuntime(req, res, next) {
    try {

        const authHeader = req.headers.authorization;

        if (!authHeader) {
            return res.status(401).json({
                erro: "Acesso não autorizado"
            });
        }

        const token = authHeader.split(" ")[1];

        const decoded = jwt.verify(token, SECRET);

        /*
        =====================================
        Validação estrutural do runtime token
        =====================================
        */

        if (!decoded.id_usuario || !decoded.id_sessao_usuario) {
            return res.status(403).json({
                erro: "Contexto runtime inválido"
            });
        }

        /*
        =====================================
        Validação sessão server-side via SP
        =====================================
        */

        // call the stored procedure which will throw if the session is invalid
        // Only validate if procedure exists
        let runtime = null;
        try {
            await pool.query("CALL sp_sessao_assert(?)", [decoded.id_sessao_usuario]);
        } catch (err) {
            if (err && (err.code === "ER_SP_DOES_NOT_EXIST" || String(err.message || "").includes("does not exist"))) {
                console.log("Procedure sp_sessao_assert not found, skipping session validation:", err.message);
            } else {
                throw err;
            }
        }

        // optionally fetch session data for heartbeat or metadata if needed
        try {
            const [[rows]] = await pool.query("CALL sp_sessao_contexto_get(?)", [decoded.id_sessao_usuario]);
            runtime = rows[0];
        } catch (err) {
            if (err && (err.code === "ER_SP_DOES_NOT_EXIST" || String(err.message || "").includes("does not exist"))) {
                console.log("Procedure sp_sessao_contexto_get not found:", err.message);
            } else {
                throw err;
            }
        }

        /*
        Heartbeat watchdog lógico - only if we have runtime data
        */
        if (runtime && runtime.ultimo_heartbeat) {
            const heartbeatTimeout = 60 * 60 * 1000;
            if ((Date.now() - new Date(runtime.ultimo_heartbeat).getTime()) > heartbeatTimeout) {
                return res.status(401).json({
                    erro: "Sessão runtime inativa"
                });
            }
        }

        req.runtime = runtime || decoded;
        req.user = decoded; // Compatibilidade com authMiddleware

        next();

    } catch (error) {

        return res.status(401).json({
            erro: "Sessão runtime inválida"
        });
    }
};
