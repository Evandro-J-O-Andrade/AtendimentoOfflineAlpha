const jwt = require("jsonwebtoken");
const pool = require("../database/mysql"); // ajuste conforme sua infra

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

        const decoded = jwt.verify(
            token,
            process.env.JWT_SECRET || "runtime_assistencial_chave"
        );

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
        Validação sessão server-side
        =====================================
        */

        const [sessao] = await pool.query(
            `SELECT 
                ativo,
                expiracao_em,
                bloqueado_ate,
                ultimo_heartbeat
             FROM sessao_usuario
             WHERE id_sessao_usuario = ?`,
            [decoded.id_sessao_usuario]
        );

        if (!sessao || sessao.length === 0) {
            return res.status(401).json({
                erro: "Sessão runtime não encontrada"
            });
        }

        const runtime = sessao[0];

        /*
        Bloqueio runtime
        */

        if (runtime.bloqueado_ate && new Date(runtime.bloqueado_ate) > new Date()) {
            return res.status(403).json({
                erro: "Sessão bloqueada"
            });
        }

        /*
        Expiração assistencial
        */

        if (runtime.expiracao_em && new Date(runtime.expiracao_em) < new Date()) {
            return res.status(401).json({
                erro: "Sessão expirada"
            });
        }

        /*
        Heartbeat watchdog lógico
        */

        const heartbeatTimeout = 60 * 60 * 1000;

        if (runtime.ultimo_heartbeat &&
            (Date.now() - new Date(runtime.ultimo_heartbeat).getTime()) > heartbeatTimeout) {

            return res.status(401).json({
                erro: "Sessão runtime inativa"
            });
        }

        req.runtime = decoded;

        next();

    } catch (error) {

        return res.status(401).json({
            erro: "Sessão runtime inválida"
        });
    }
};