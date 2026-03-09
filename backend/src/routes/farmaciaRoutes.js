const express = require("express");
const router = express.Router();
const authMiddleware = require("../auth/authMiddleware");

/**
 * ======================================
 * ROTAS DE FARMÁCIA
 * Sistema de dispensação de medicamentos
 * ======================================
 */

/**
 * GET /api/farmacia/pendentes
 * Lista dispensações pendentes
 */
router.get("/pendentes", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const [pendentes] = await conn.query(`
            SELECT 
                fd.id_farmacia_dispensacao,
                fd.id_paciente,
                fd.id_prescricao,
                fd.status,
                fd.data_solicitacao,
                fd.data_dispensacao,
                p.nome as paciente_nome,
                p.cns as paciente_cns,
                u.nome as solicitante_nome
            FROM farmacia_dispensacao fd
            LEFT JOIN paciente p ON p.id = fd.id_paciente
            LEFT JOIN usuario u ON u.id_usuario = fd.id_solicitante
            WHERE fd.id_unidade = ?
            AND fd.status IN ('SOLICITADO', 'EM_PREPARACAO')
            ORDER BY fd.data_solicitacao ASC
        `, [req.user.id_unidade]);

        res.json({ pendentes });

    } catch (err) {
        console.error("Erro ao buscar dispensas pendentes:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_PENDENTES" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/farmacia/prescricoes/:id_paciente
 * Lista prescrições de um paciente
 */
router.get("/prescricoes/:id_paciente", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id_paciente } = req.params;

        const [prescricoes] = await conn.query(`
            SELECT 
                p.id_prescricao,
                p.data_prescricao,
                p.id_medico,
                p.status as prescricao_status,
                p.observacoes,
                m.nome as medico_nome,
                m.crm as medico_crm,
                mp.id_medicamento,
                mp.quantidade,
                mp.frequencia,
                mp.duracao,
                mp.posologia,
                mp.uso,
                med.codigo as medicamento_codigo,
                med.nome as medicamento_nome,
                med.apresentacao,
                med.concentracao
            FROM prescricao p
            LEFT JOIN usuario m ON m.id_usuario = p.id_medico
            LEFT JOIN prescricao_medicamento mp ON mp.id_prescricao = p.id_prescricao
            LEFT JOIN medicamento med ON med.id_medicamento = mp.id_medicamento
            WHERE p.id_paciente = ?
            AND p.status = 'ATIVA'
            ORDER BY p.data_prescricao DESC
        `, [id_paciente]);

        res.json({ prescricoes });

    } catch (err) {
        console.error("Erro ao buscar prescrições:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_PRESCRICOES" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/farmacia/medicamentos
 * Lista medicamentos disponíveis
 */
router.get("/medicamentos", async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { busca } = req.query;
        
        let query = `
            SELECT 
                m.id_medicamento,
                m.codigo,
                m.nome,
                m.apresentacao,
                m.concentracao,
                m.principio_ativo,
                m.controlado,
                m.uso,
                e.quantidade as estoque_atual,
                e.quantidade_minima as estoque_minimo
            FROM medicamento m
            LEFT JOIN medicamento_estoque e ON e.id_medicamento = m.id_medicamento
            WHERE m.ativo = 1
        `;
        
        const params = [];
        
        if (busca) {
            query += ` AND (m.nome LIKE ? OR m.principio_ativo LIKE ? OR m.codigo LIKE ?)`;
            const buscaTermo = `%${busca}%`;
            params.push(buscaTermo, buscaTermo, buscaTermo);
        }
        
        query += ` ORDER BY m.nome ASC`;

        const [medicamentos] = await conn.query(query, params);

        res.json({ medicamentos });

    } catch (err) {
        console.error("Erro ao buscar medicamentos:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_MEDICAMENTOS" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/farmacia/dispensar
 * Realiza dispensação de medicamento
 */
router.post("/dispensar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { 
            id_dispensacao,
            id_paciente,
            id_prescricao,
            itens
        } = req.body;

        const connection = await require("../config/database").getConnection();
        
        await connection.beginTransaction();

        try {
            // Registra cada item dispensado
            for (const item of itens) {
                await connection.query(`
                    INSERT INTO farmacia_dispensacao_item (
                        id_dispensacao,
                        id_medicamento,
                        quantidade,
                        lote,
                        validade,
                        data_dispensacao
                    ) VALUES (?, ?, ?, ?, ?, NOW())
                `, [
                    id_dispensacao,
                    item.id_medicamento,
                    item.quantidade,
                    item.lote || null,
                    item.validade || null
                ]);

                // Atualiza estoque
                await connection.query(`
                    UPDATE medicamento_estoque
                    SET quantidade = quantidade - ?
                    WHERE id_medicamento = ?
                `, [item.quantidade, item.id_medicamento]);
            }

            // Atualiza status da dispensação
            await connection.query(`
                UPDATE farmacia_dispensacao
                SET status = 'DISPENSADO',
                    id_farmacutico = ?,
                    data_dispensacao = NOW()
                WHERE id_farmacia_dispensacao = ?
            `, [req.user.id_usuario, id_dispensacao]);

            await connection.commit();

            res.json({ 
                success: true, 
                mensagem: "Dispensação realizada com sucesso"
            });

        } catch (err) {
            await connection.rollback();
            throw err;
        } finally {
            connection.release();
        }

    } catch (err) {
        console.error("Erro ao realizar dispensação:", err);
        res.status(500).json({ error: "ERRO_AO_DISPENSAR" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/farmacia/solicitar
 * Solicita dispensação de medicamentos
 */
router.post("/solicitar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { 
            id_paciente,
            id_prescricao,
            id_local_operacional,
            itens,
            observacoes
        } = req.body;

        // Cria solicitação de dispensação
        const [result] = await conn.query(`
            INSERT INTO farmacia_dispensacao (
                id_paciente,
                id_prescricao,
                id_unidade,
                id_local_operacional,
                id_solicitante,
                status,
                observacoes,
                data_solicitacao
            ) VALUES (?, ?, ?, ?, ?, 'SOLICITADO', ?, NOW())
        `, [
            id_paciente,
            id_prescricao,
            req.user.id_unidade,
            id_local_operacional,
            req.user.id_usuario,
            observacoes
        ]);

        const id_dispensacao = result.insertId;

        // Adiciona itens da solicitação
        for (const item of itens) {
            await conn.query(`
                INSERT INTO farmacia_dispensacao_item (
                    id_dispensacao,
                    id_medicamento,
                    quantidade_solicitada
                ) VALUES (?, ?, ?)
            `, [id_dispensacao, item.id_medicamento, item.quantidade]);
        }

        res.json({ 
            success: true, 
            id_dispensacao,
            mensagem: "Solicitação enviada para farmácia"
        });

    } catch (err) {
        console.error("Erro ao solicitar dispensação:", err);
        res.status(500).json({ error: "ERRO_AO_SOLICITAR" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/farmacia/historico/:id_paciente
 * Histórico de dispensações de um paciente
 */
router.get("/historico/:id_paciente", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id_paciente } = req.params;

        const [historico] = await conn.query(`
            SELECT 
                fd.id_farmacia_dispensacao,
                fd.status,
                fd.data_solicitacao,
                fd.data_dispensacao,
                fd.observacoes,
                u_farm.nome as farmacutico_nome,
                u_sol.nome as solicitante_nome,
                fdi.id_medicamento,
                med.nome as medicamento_nome,
                fdi.quantidade,
                fdi.lote
            FROM farmacia_dispensacao fd
            LEFT JOIN farmacia_dispensacao_item fdi ON fdi.id_dispensacao = fd.id_farmacia_dispensacao
            LEFT JOIN medicamento med ON med.id_medicamento = fdi.id_medicamento
            LEFT JOIN usuario u_farm ON u_farm.id_usuario = fd.id_farmacutico
            LEFT JOIN usuario u_sol ON u_sol.id_usuario = fd.id_solicitante
            WHERE fd.id_paciente = ?
            ORDER BY fd.data_solicitacao DESC
        `, [id_paciente]);

        res.json({ historico });

    } catch (err) {
        console.error("Erro ao buscar histórico:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_HISTORICO" });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;
