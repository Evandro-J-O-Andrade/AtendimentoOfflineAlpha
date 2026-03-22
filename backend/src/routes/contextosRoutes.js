const express = require("express");
const authMiddleware = require("../auth/authMiddleware");
const { executeSPMaster } = require("../services/spMasterService.js");

const router = express.Router();

// GET /api/contextos - Meus contextos disponíveis
router.get("/", authMiddleware, async (req, res) => {
    const { id_sessao_usuario } = req.user;

    if (!id_sessao_usuario) {
        return res.status(401).json({ erro: "SESSAO_NAO_INFORMADA" });
    }

    try {
        const { sucesso, resultado, mensagem } = await executeSPMaster(
            "GET",
            "AUTH.CONTEXTO_GET",
            id_sessao_usuario
        );

        if (!sucesso) {
            return res.status(500).json({ erro: mensagem || "ERRO_INTERNO" });
        }

        return res.json({ contextos: resultado || [] });
    } catch (err) {
        console.error("Erro ao buscar contextos:", err);
        return res.status(500).json({ erro: "ERRO_INTERNO" });
    }
});

module.exports = router;
