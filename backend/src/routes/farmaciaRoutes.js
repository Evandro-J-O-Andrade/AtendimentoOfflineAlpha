const express = require("express");
const router = express.Router();
const authMiddleware = require("../auth/authMiddleware");
const farmaciaController = require("../controllers/farmaciaController");

// Todas as rotas de farmácia requerem autenticação
router.use(authMiddleware);

// Buscar prescrições por termo
router.get("/buscar", async (req, res, next) => {
    // Adicionar id_sessao ao request para uso do controller
    req.id_sessao = req.user.id_sessao_usuario;
    await farmaciaController.buscarPrescricoes(req, res);
});

// Dispensar medicamento
router.post("/dispensar", async (req, res, next) => {
    req.id_sessao = req.user.id_sessao_usuario;
    await farmaciaController.dispensarMedicamento(req, res);
});

// Finalizar dispensação
router.post("/:id/finalizar", async (req, res, next) => {
    req.id_sessao = req.user.id_sessao_usuario;
    await farmaciaController.finalizarDispensacao(req, res);
});

// Buscar histórico de dispensação
router.get("/historico", async (req, res, next) => {
    req.id_sessao = req.user.id_sessao_usuario;
    await farmaciaController.buscarHistorico(req, res);
});

module.exports = router;
