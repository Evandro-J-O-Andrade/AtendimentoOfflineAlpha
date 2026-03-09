const express = require("express");
const router = express.Router();
const authMiddleware = require("../auth/authMiddleware");

/**
 * ======================================
 * ROTAS DE TRIAGEM
 * Sistema de classificação de risco e acolhimento
 * ======================================
 */

/**
 * GET /api/triagem/pendentes
 * Lista pacientes aguardando triagem
 */
router.get("/pendentes", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const [pacientes] = await conn.query(`
            SELECT 
                fo.id_fila,
                fo.id_paciente,
                fo.prioridade,
                fo.data_entrada,
                fo.posicao,
                p.nome as paciente_nome,
                p.cns as paciente_cns,
                p.data_nascimento,
                TIMESTAMPDIFF(YEAR, p.data_nascimento, CURDATE()) as idade
            FROM fila_operacional fo
            LEFT JOIN paciente p ON p.id = fo.id_paciente
            WHERE fo.id_unidade = ?
            AND fo.status = 'AGUARDANDO'
            ORDER BY 
                CASE fo.prioridade
                    WHEN 'EMERGENCIA' THEN 1
                    WHEN 'URGENTE' THEN 2
                    WHEN 'PREFERENCIAL' THEN 3
                    ELSE 4
                END,
                fo.posicao ASC
        `, [req.user.id_unidade]);

        res.json({ pacientes });

    } catch (err) {
        console.error("Erro ao buscar triagens pendentes:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_PENDENTES" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/triagem/classificacoes
 * Lista classificações de risco disponíveis
 */
router.get("/classificacoes", async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const [classificacoes] = await conn.query(`
            SELECT 
                id_risco,
                nome,
                cor,
                descricao,
                tempo_maximo
            FROM classificacao_risco
            WHERE ativo = 1
            ORDER BY id_risco ASC
        `);

        res.json({ classificacoes });

    } catch (err) {
        console.error("Erro ao buscar classificações:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_CLASSIFICACOES" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/triagem/iniciar
 * Inicia avaliação de triagem
 */
router.post("/iniciar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id_fila, id_paciente } = req.body;
        
        // Atualiza status da fila
        await conn.query(`
            UPDATE fila_operacional
            SET status = 'EM_TRIAGEM'
            WHERE id_fila = ?
        `, [id_fila]);

        res.json({ success: true, mensagem: "Triagem iniciada" });

    } catch (err) {
        console.error("Erro ao iniciar triagem:", err);
        res.status(500).json({ error: "ERRO_AO_INICIAR_TRIAGEM" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/triagem/salvar
 * Salva avaliação de triagem com classificação de risco
 */
router.post("/salvar", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { 
            id_fila,
            id_paciente,
            id_classificacao_risco,
            pressao_sistolica,
            pressao_diastolica,
            frequencia_cardiaca,
            frequencia_respiratoria,
            temperatura,
            saturacao_oxigenio,
            glicemia,
            peso,
            altura,
            queixas,
            historico_alergias,
            uso_medicamentos,
            observacoes
        } = req.body;

        // Busca dados do paciente
        const [paciente] = await conn.query(`
            SELECT id FROM paciente WHERE id = ?
        `, [id_paciente]);

        let idPaciente = id_paciente;
        
        // Se não existir, cria registro básico
        if (paciente.length === 0) {
            const [result] = await conn.query(`
                INSERT INTO paciente (nome, cns, criado_em)
                VALUES ('Paciente Temporário', NULL, NOW())
            `);
            idPaciente = result.insertId;
        }

        // Insere triagem
        const [result] = await conn.query(`
            INSERT INTO triagem (
                id_paciente,
                id_usuario_enfermeiro,
                id_classificacao_risco,
                pressao_sistolica,
                pressao_diastolica,
                frequencia_cardiaca,
                frequencia_respiratoria,
                temperatura,
                saturacao_oxigenio,
                glicemia,
                peso,
                altura,
                queixas,
                historico_alergias,
                uso_medicamentos,
                observacoes,
                data_triagem
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
        `, [
            idPaciente,
            req.user.id_usuario,
            id_classificacao_risco,
            pressao_sistolica || null,
            pressao_diastolica || null,
            frequencia_cardiaca || null,
            frequencia_respiratoria || null,
            temperatura || null,
            saturacao_oxigenio || null,
            glicemia || null,
            peso || null,
            altura || null,
            queixas || null,
            historico_alergias || null,
            uso_medicamentos || null,
            observacoes || null
        ]);

        const id_triagem = result.insertId;

        // Atualiza fila com nova prioridade
        await conn.query(`
            UPDATE fila_operacional
            SET status = 'AGUARDANDO',
                prioridade = (
                    SELECT nome FROM classificacao_risco WHERE id_risco = ?
                )
            WHERE id_fila = ?
        `, [id_classificacao_risco, id_fila]);

        // Registra sinais vitais
        await conn.query(`
            INSERT INTO sinais_vitais (
                id_paciente,
                id_atendimento,
                pressao_sistolica,
                pressao_diastolica,
                frequencia_cardiaca,
                frequencia_respiratoria,
                temperatura,
                saturacao_oxigenio,
                glicemia,
                peso,
                altura,
                data_registro
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
        `, [
            idPaciente,
            id_triagem,
            pressao_sistolica || null,
            pressao_diastolica || null,
            frequencia_cardiaca || null,
            frequencia_respiratoria || null,
            temperatura || null,
            saturacao_oxigenio || null,
            glicemia || null,
            peso || null,
            altura || null
        ]);

        res.json({ 
            success: true, 
            id_triagem,
            mensagem: "Triagem salva com sucesso"
        });

    } catch (err) {
        console.error("Erro ao salvar triagem:", err);
        res.status(500).json({ error: "ERRO_AO_SALVAR_TRIAGEM" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/triagem/:id
 * Busca detalhes de uma triagem
 */
router.get("/:id", authMiddleware, async (req, res) => {
    let conn;
    try {
        conn = await require("../config/database").getConnection();
        
        const { id } = req.params;

        const [triagem] = await conn.query(`
            SELECT 
                t.*,
                p.nome as paciente_nome,
                p.cns as paciente_cns,
                cr.nome as classificacao_nome,
                cr.cor as classificacao_cor,
                u.nome as enfermeiro_nome
            FROM triagem t
            LEFT JOIN paciente p ON p.id = t.id_paciente
            LEFT JOIN classificacao_risco cr ON cr.id_risco = t.id_classificacao_risco
            LEFT JOIN usuario u ON u.id_usuario = t.id_usuario_enfermeiro
            WHERE t.id_triagem = ?
        `, [id]);

        if (triagem.length === 0) {
            return res.status(404).json({ error: "TRIAGEM_NAO_ENCONTRADA" });
        }

        res.json({ triagem: triagem[0] });

    } catch (err) {
        console.error("Erro ao buscar triagem:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_TRIAGEM" });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;
