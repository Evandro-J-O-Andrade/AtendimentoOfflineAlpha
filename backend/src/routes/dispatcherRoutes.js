const express = require('express');
const router = express.Router();
const authMiddleware = require('../auth/authMiddleware');
const db = require('../config/database');

/**
 * ================================================================
 * RUNTIME DISPATCHER GATEWAY
 * ================================================================
 * Ponto único de entrada para todas as ações de escrita (Write)
 * seguindo a arquitetura canônica New Wave Enterprise.
 * 
 * Endpoint: POST /api/runtime/dispatch
 * ================================================================
 */
router.post('/dispatch', authMiddleware, async (req, res) => {
    const { acao, payload } = req.body;
    
    // O authMiddleware deve garantir que id_sessao_usuario esteja no req.user
    const id_sessao = req.user.id_sessao_usuario;

    if (!acao) {
        return res.status(400).json({ 
            ok: false, 
            error: "Ação (Command) não definida no payload." 
        });
    }

    let conn;
    try {
        conn = await db.getConnection();

        // Execução da Stored Procedure Orquestradora
        // sp_master_dispatcher(p_id_sessao, p_acao, p_payload_json)
        const [result] = await conn.query(
            "CALL sp_master_dispatcher(?, ?, ?)",
            [id_sessao, acao, JSON.stringify(payload || {})]
        );

        // O MySQL retorna um array de resultados. 
        // O primeiro índice contém os SELECTs realizados dentro da SP.
        res.json({
            ok: true,
            data: result[0] || { message: "Comando executado com sucesso" }
        });

    } catch (err) {
        console.error(`[DISPATCH ERROR] Action: ${acao} | User: ${req.user.id_usuario}`, err);
        
        // Erros lançados via SIGNAL SQLSTATE '45000' nas SPs cairão aqui
        res.status(err.sqlState === '45000' ? 400 : 500).json({
            ok: false,
            error: err.message || "Erro interno na execução do comando."
        });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;