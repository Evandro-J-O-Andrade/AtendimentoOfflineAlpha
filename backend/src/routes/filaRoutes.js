const express = require("express");
const router = express.Router();
const authMiddleware = require("../auth/authMiddleware");

/**
 * ======================================
 * ROTAS DE FILA OPERACIONAL
 * Sistema de gerenciamento de fila de atendimento
 * ======================================
 */

/**
 * GET /api/fila
 * Lista todos os pacientes na fila
 */
router.get("/", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const [fila] = await conn.query(`
            SELECT 
                fo.id_fila,
                fo.id_paciente,
                fo.id_unidade,
                fo.id_local_operacional,
                fo.status,
                fo.prioridade,
                fo.posicao,
                fo.data_entrada,
                fo.data_atendimento,
                p.nome as paciente_nome,
                p.cns as paciente_cns,
                lo.nome as local_nome,
                u.nome as unidade_nome
            FROM fila_operacional fo
            LEFT JOIN paciente p ON p.id = fo.id_paciente
            LEFT JOIN local_operacional lo ON lo.id_local_operacional = fo.id_local_operacional
            LEFT JOIN unidade u ON u.id_unidade = fo.id_unidade
            WHERE fo.id_unidade = ?
            AND fo.status IN ('AGUARDANDO', 'EM_ATENDIMENTO', 'CHAMADO')
            ORDER BY 
                CASE fo.prioridade
                    WHEN 'EMERGENCIA' THEN 1
                    WHEN 'URGENTE' THEN 2
                    WHEN 'PREFERENCIAL' THEN 3
                    ELSE 4
                END,
                fo.posicao ASC
        `, [req.user.id_unidade]);

        res.json({ fila });

    } catch (err) {
        console.error("Erro ao buscar fila:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_FILA" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/fila/chamar
 * Chama próximo paciente da fila
 */
router.post("/chamar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id_local_operacional } = req.body;
        
        // Busca próximo paciente da fila
        const [paciente] = await conn.query(`
            SELECT id_fila, id_paciente, posicao, prioridade
            FROM fila_operacional
            WHERE id_unidade = ?
            AND status = 'AGUARDANDO'
            ORDER BY 
                CASE prioridade
                    WHEN 'EMERGENCIA' THEN 1
                    WHEN 'URGENTE' THEN 2
                    WHEN 'PREFERENCIAL' THEN 3
                    ELSE 4
                END,
                posicao ASC
            LIMIT 1
        `, [req.user.id_unidade]);

        if (paciente.length === 0) {
            return res.status(404).json({ error: "FILA_VAZIA" });
        }

        // Atualiza status para CHAMADO
        await conn.query(`
            UPDATE fila_operacional
            SET status = 'CHAMADO', data_atendimento = NOW()
            WHERE id_fila = ?
        `, [paciente[0].id_fila]);

        // Registra evento
        await conn.query(`
            INSERT INTO fila_operacional_evento 
            (id_fila, evento, id_usuario, ip_acesso)
            VALUES (?, 'CHAMADO', ?, ?)
        `, [paciente[0].id_fila, req.user.id_usuario, req.ip]);

        res.json({ 
            success: true, 
            paciente: paciente[0],
            mensagem: "Paciente chamado"
        });

    } catch (err) {
        console.error("Erro ao chamar paciente:", err);
        res.status(500).json({ error: "ERRO_AO_CHAMAR" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/fila/iniciar-atendimento
 * Inicia atendimento do paciente chamado
 */
router.post("/iniciar-atendimento", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id_fila } = req.body;
        
        // Atualiza status para EM_ATENDIMENTO
        await conn.query(`
            UPDATE fila_operacional
            SET status = 'EM_ATENDIMENTO', data_atendimento = NOW()
            WHERE id_fila = ?
        `, [id_fila]);

        // Registra evento
        await conn.query(`
            INSERT INTO fila_operacional_evento 
            (id_fila, evento, id_usuario, ip_acesso)
            VALUES (?, 'INICIADO', ?, ?)
        `, [id_fila, req.user.id_usuario, req.ip]);

        res.json({ success: true, mensagem: "Atendimento iniciado" });

    } catch (err) {
        console.error("Erro ao iniciar atendimento:", err);
        res.status(500).json({ error: "ERRO_AO_INICIAR" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/fila/finalizar
 * Finaliza atendimento e remove da fila
 */
router.post("/finalizar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id_fila, destino } = req.body; // destino: ALTA, ENCAMINHAMENTO, RETORNO
        
        // Atualiza status para FINALIZADO
        await conn.query(`
            UPDATE fila_operacional
            SET status = 'FINALIZADO', data_atendimento = NOW()
            WHERE id_fila = ?
        `, [id_fila]);

        // Registra evento
        await conn.query(`
            INSERT INTO fila_operacional_evento 
            (id_fila, evento, id_usuario, ip_acesso)
            VALUES (?, ?, ?, ?)
        `, [id_fila, `FINALIZADO_${destino || 'ALTA'}`, req.user.id_usuario, req.ip]);

        res.json({ success: true, mensagem: "Atendimento finalizados" });

    } catch (err) {
        console.error("Erro ao finalizar:", err);
        res.status(500).json({ error: "ERRO_AO_FINALIZAR" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/fila/encaminhar
 * Encaminha paciente para outro local
 */
router.post("/encaminhar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id_fila, id_local_destino, motivo } = req.body;
        
        // Atualiza local operacional
        await conn.query(`
            UPDATE fila_operacional
            SET id_local_operacional = ?, 
                status = 'AGUARDANDO',
                prioridade = 'URGENTE'
            WHERE id_fila = ?
        `, [id_local_destino, id_fila]);

        // Registra evento
        await conn.query(`
            INSERT INTO fila_operacional_evento 
            (id_fila, evento, id_usuario, ip_acesso)
            VALUES (?, 'ENCAMINHAMENTO', ?, ?)
        `, [id_fila, req.user.id_usuario, req.ip]);

        res.json({ success: true, mensagem: "Paciente encaminhados" });

    } catch (err) {
        console.error("Erro ao encaminhar:", err);
        res.status(500).json({ error: "ERRO_AO_ENCAMINHAR" });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;
