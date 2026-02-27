const jwt = require("jsonwebtoken");

/*
=====================================
Guardião Runtime Assistencial
Protege contexto clínico operacional
=====================================
*/

module.exports = function guardiaoRuntime(req, res, next) {

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
        Contexto runtime obrigatório
        */
        if (!decoded.id_usuario || !decoded.id_sistema) {
            return res.status(403).json({
                erro: "Contexto runtime inválido"
            });
        }

        req.runtime = decoded;

        next();

    } catch (error) {
        return res.status(401).json({
            erro: "Sessão runtime expirada"
        });
    }
};