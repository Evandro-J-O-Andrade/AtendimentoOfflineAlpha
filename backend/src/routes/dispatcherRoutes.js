const express = require('express');
const router = express.Router();
const { executeMasterDispatcher } = require('../services/dispatcherService');

/**
 * POST /api/dispatcher
 * Rota central para executar ações via sp_master_dispatcher
 */
router.post('/dispatcher', async (req, res) => {
    const { 
        id_sessao, 
        dominio, 
        acao, 
        id_referencia, 
        payload, 
        uuid_transacao 
    } = req.body;

    if (!id_sessao || !dominio || !acao) {
        return res.status(400).json({ error: "id_sessao, dominio e acao são obrigatórios" });
    }

    try {
        const result = await executeMasterDispatcher({
            id_sessao,
            dominio,
            acao,
            id_referencia,
            payload,
            uuid_transacao
        });
        return res.status(200).json(result);
    } catch (error) {
        console.error('ERRO_DISPATCHER:', error.message);
        return res.status(500).json({
            success: false,
            message: error.message
        });
    }
});

module.exports = router;
