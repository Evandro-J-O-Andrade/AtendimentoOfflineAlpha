const express = require("express");

const runtimeGuard = require("../runtime/runtimeGuard");
const SnapshotValidator = require("../runtime/snapshotValidator");
const OracleEngine = require("../runtime/oracleEngine");

const router = express.Router();

router.post("/fluxo/executar", runtimeGuard, async (req, res) => {

    try {

        const runtime_session = req.runtime_session;

        // Simulação de snapshot (deve vir do banco depois)
        const snapshot_runtime = req.body.snapshot_runtime;
        const snapshot_central = req.body.snapshot_central;

        const protocolo_valido =
            SnapshotValidator.validar(
                snapshot_runtime,
                snapshot_central
            );

        const decisao = await OracleEngine.decidir({
            runtime_session,
            protocolo_valido,
            snapshot_valido: protocolo_valido
        });

        if (decisao !== "PERMITIR") {
            return res.status(403).json({
                status: decisao
            });
        }

        // Aqui você executaria o fluxo assistencial real
        // Ledger, workflow, etc

        return res.json({
            status: "EXECUTADO",
            oracle: decisao
        });

    } catch (err) {

        return res.status(500).json({
            error: "FLUXO_RUNTIME_ERROR",
            message: err.message
        });

    }

});

module.exports = router;