const express = require("express");
const router = express.Router();
const authMiddleware = require("../auth/authMiddleware");
const db = require("../config/database");

/**
 * ======================================
 * ROTAS DE FILA - PADRÃO CANÔNICO
 * Frontend -> API -> sp_master_dispatcher -> executores
 * ======================================
 * 
 * Assinatura: sp_master_dispatcher(
 *     p_id_sessao BIGINT,
 *     p_dominio VARCHAR(50),      -- 'FILA', 'ASSISTENCIAL', 'ESTOQUE', 'FATURAMENTO'
 *     p_acao VARCHAR(100),        -- 'GERAR_SENHA', 'CHAMAR_PAINEL', etc
 *     p_id_referencia BIGINT,    -- ID da senha/atendimento
 *     p_payload JSON,             -- Dados complementares
 *     OUT p_resultado JSON,
 *     OUT p_sucesso BOOLEAN,
 *     OUT p_mensagem TEXT
 * )
 */

/**
 * POST /api/fila/gerar
 * Gerar nova senha na fila
 * Backend chama: sp_master_dispatcher(p_id_sessao, 'FILA', 'GERAR_SENHA', NULL, payload)
 */
router.post("/gerar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await db.getConnection();
        
        const { tipo, prioridade, origem } = req.body;
        const id_sessao = req.user.id_sessao_usuario;
        const uuid_transacao = require('uuid').v4();
        
        const payload = JSON.stringify({
            tipo: tipo || 'NORMAL',
            prioridade: prioridade || 0,
            origem: origem || 'FILA'
        });

        // Chamar sp_master_dispatcher (6 params - sem OUTPUT)
        // sp_master_dispatcher(p_id_sessao, p_uuid_transacao, p_dominio, p_acao, p_id_referencia, p_payload)
        await conn.query(
            `CALL sp_master_dispatcher(?, ?, ?, ?, ?, ?)`,
            [id_sessao, uuid_transacao, 'FILA', 'GERAR_SENHA', null, payload]
        );

        // Buscar resultado da auditoria
        const [[resultado]] = await conn.query(
            `SELECT * FROM auditoria_evento WHERE uuid_transacao = ? LIMIT 1`,
            [uuid_transacao]
        );

        res.json({
            sucesso: resultado?.status === 'SUCESSO',
            mensagem: resultado?.status || 'OK',
            dados: resultado?.detalhe ? JSON.parse(resultado.detalhe) : null
        });

    } catch (err) {
        console.error("Erro ao gerar senha:", err);
        res.status(500).json({ sucesso: false, mensagem: "Erro ao gerar senha", erro: err.message });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/fila
 * Listar fila de atendimento
 * Backend chama: view vw_gestao_fluxo_tempo_real
 */
router.get("/", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await db.getConnection();
        
        const id_unidade = req.user.id_unidade;

        // Busca via view (mais eficiente para leitura)
        const [fila] = await conn.query(`
            SELECT * FROM vw_gestao_fluxo_tempo_real
            WHERE id_unidade = ?
            AND status IN ('AGUARDANDO', 'CHAMADO', 'EM_ATENDIMENTO')
            ORDER BY 
                CASE nivel_risco
                    WHEN 'VERMELHO' THEN 1
                    WHEN 'LARANJA' THEN 2
                    WHEN 'AMARELO' THEN 3
                    WHEN 'VERDE' THEN 4
                    WHEN 'AZUL' THEN 5
                    ELSE 6
                END,
                posicao ASC
        `, [id_unidade]);

        res.json({ sucesso: true, fila });

    } catch (err) {
        console.error("Erro ao buscar fila:", err);
        res.status(500).json({ sucesso: false, mensagem: "Erro ao buscar fila" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/fila/chamar
 * Chamar próximo paciente da fila
 * Backend chama: sp_master_dispatcher(p_id_sessao, 'FILA', 'CHAMAR_PAINEL', id_senha, payload)
 */
router.post("/chamar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await db.getConnection();
        
        const { id_senha, id_guiche } = req.body;
        const id_sessao = req.user.id_sessao_usuario;
        
        const payload = JSON.stringify({
            estado_destino: 'CHAMADO',
            id_guiche: id_guiche || 1
        });

        // Chamar sp_master_dispatcher
        await conn.query(
            `CALL sp_master_dispatcher(?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
            [id_sessao, 'FILA', 'CHAMAR_PAINEL', id_senha, payload]
        );

        const [[output]] = await conn.query(
            `SELECT @resultado as resultado, @sucesso as sucesso, @mensagem as mensagem`
        );

        res.json({
            sucesso: output.sucesso === 1 || output.sucesso === true,
            mensagem: output.mensagem,
            dados: output.resultado ? JSON.parse(output.resultado) : null
        });

    } catch (err) {
        console.error("Erro ao chamar paciente:", err);
        res.status(500).json({ sucesso: false, mensagem: "Erro ao chamar paciente" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/fila/iniciar
 * Iniciar atendimento
 * Backend chama: sp_master_dispatcher(p_id_sessao, 'FILA', 'INICIAR_ATENDIMENTO', id_senha, payload)
 */
router.post("/iniciar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await db.getConnection();
        
        const { id_senha } = req.body;
        const id_sessao = req.user.id_sessao_usuario;
        
        const payload = JSON.stringify({
            estado_destino: 'EM_ATENDIMENTO'
        });

        // Chamar sp_master_dispatcher
        await conn.query(
            `CALL sp_master_dispatcher(?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
            [id_sessao, 'FILA', 'INICIAR_ATENDIMENTO', id_senha, payload]
        );

        const [[output]] = await conn.query(
            `SELECT @resultado as resultado, @sucesso as sucesso, @mensagem as mensagem`
        );

        res.json({
            sucesso: output.sucesso === 1 || output.sucesso === true,
            mensagem: output.mensagem,
            dados: output.resultado ? JSON.parse(output.resultado) : null
        });

    } catch (err) {
        console.error("Erro ao iniciar atendimento:", err);
        res.status(500).json({ sucesso: false, mensagem: "Erro ao iniciar atendimento" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/fila/finalizar
 * Finalizar atendimento
 * Backend chama: sp_master_dispatcher(p_id_sessao, 'FILA', 'FINALIZAR_ATENDIMENTO', id_senha, payload)
 */
router.post("/finalizar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await db.getConnection();
        
        const { id_senha, destino } = req.body;
        const id_sessao = req.user.id_sessao_usuario;
        
        const payload = JSON.stringify({
            estado_destino: 'CONCLUIDO',
            destino: destino || 'ALTA'
        });

        // Chamar sp_master_dispatcher
        await conn.query(
            `CALL sp_master_dispatcher(?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
            [id_sessao, 'FILA', 'FINALIZAR_ATENDIMENTO', id_senha, payload]
        );

        const [[output]] = await conn.query(
            `SELECT @resultado as resultado, @sucesso as sucesso, @mensagem as mensagem`
        );

        res.json({
            sucesso: output.sucesso === 1 || output.sucesso === true,
            mensagem: output.mensagem,
            dados: output.resultado ? JSON.parse(output.resultado) : null
        });

    } catch (err) {
        console.error("Erro ao finalizar atendimento:", err);
        res.status(500).json({ sucesso: false, mensagem: "Erro ao finalizar" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/fila/encaminhar
 * Encaminhar paciente para outro local
 * Backend chama: sp_master_dispatcher(p_id_sessao, 'FILA', 'ENCAMINHAR', id_senha, payload)
 */
router.post("/encaminhar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await db.getConnection();
        
        const { id_senha, id_local_destino, motivo } = req.body;
        const id_sessao = req.user.id_sessao_usuario;
        
        const payload = JSON.stringify({
            id_local_destino,
            motivo
        });

        // Chamar sp_master_dispatcher
        await conn.query(
            `CALL sp_master_dispatcher(?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
            [id_sessao, 'FILA', 'ENCAMINHAR', id_senha, payload]
        );

        const [[output]] = await conn.query(
            `SELECT @resultado as resultado, @sucesso as sucesso, @mensagem as mensagem`
        );

        res.json({
            sucesso: output.sucesso === 1 || output.sucesso === true,
            mensagem: output.mensagem,
            dados: output.resultado ? JSON.parse(output.resultado) : null
        });

    } catch (err) {
        console.error("Erro ao encaminhar:", err);
        res.status(500).json({ sucesso: false, mensagem: "Erro ao encaminhar" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/fila/cancelar
 * Cancelar senha
 * Backend chama: sp_master_dispatcher(p_id_sessao, 'FILA', 'CANCELAR_SENHA', id_senha, payload)
 */
router.post("/cancelar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await db.getConnection();
        
        const { id_senha, motivo } = req.body;
        const id_sessao = req.user.id_sessao_usuario;
        
        const payload = JSON.stringify({
            motivo: motivo || 'Cancelado pelo atendente'
        });

        // Chamar sp_master_dispatcher
        await conn.query(
            `CALL sp_master_dispatcher(?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
            [id_sessao, 'FILA', 'CANCELAR_SENHA', id_senha, payload]
        );

        const [[output]] = await conn.query(
            `SELECT @resultado as resultado, @sucesso as sucesso, @mensagem as mensagem`
        );

        res.json({
            sucesso: output.sucesso === 1 || output.sucesso === true,
            mensagem: output.mensagem,
            dados: output.resultado ? JSON.parse(output.resultado) : null
        });

    } catch (err) {
        console.error("Erro ao cancelar senha:", err);
        res.status(500).json({ sucesso: false, mensagem: "Erro ao cancelar" });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;
