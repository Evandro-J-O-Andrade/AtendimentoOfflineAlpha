const express = require("express");
const authMiddleware = require("../auth/authMiddleware");

const runtimeGuard = require("../runtime/runtimeGuard");
const SnapshotValidator = require("../runtime/snapshotValidator");
const OracleEngine = require("../runtime/oracleEngine");

const router = express.Router();

/**
 * ======================================
 * ROTAS OPERACIONAIS - MÓDULO RECEPÇÃO
 * ======================================
 */

// ======================================
// ROTAS DE PACIENTE
// ======================================

/**
 * GET /api/operacional/pacientes
 * Busca pacientes por termo (CPF ou Nome)
 * SP: sp_paciente_buscar
 */
router.get("/pacientes", authMiddleware, async (req, res) => {
    const { termo } = req.query;
    let conn;
    
    if (!termo || termo.trim().length < 3) {
        return res.json({ pacientes: [] });
    }
    
    try {
        conn = await require("../config/database").getConnection();
        
        const termoBusca = `%${termo}%`;
        
        // Busca pacientes por CPF ou Nome
        const [pacientes] = await conn.query(
            "SELECT p.id, p.nome, p.cpf, p.cns, p.data_nascimento, p.sexo, p.telefone, p.endereco, p.bairro, p.cidade, p.uf FROM paciente p WHERE p.ativo = 1 AND (p.nome LIKE ? OR p.cpf LIKE ? OR p.cns LIKE ?) LIMIT 20",
            [termoBusca, termoBusca, termoBusca]
        );
        
        res.json({ pacientes });
        
    } catch (err) {
        console.error("Erro ao buscar pacientes:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_PACIENTES" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/operacional/atendimentos
 * Cria atendimento (FFA)
 * SP: sp_master_atendimento_iniciar
 */
router.post("/atendimentos", authMiddleware, async (req, res) => {
    const { id_paciente, tipo_atendimento } = req.body;
    let conn;
    
    if (!id_paciente) {
        return res.status(400).json({ error: "ID_PACIENTE_OBRIGATORIO" });
    }
    
    try {
        conn = await require("../config/database").getConnection();
        
        // Chama a SP de iniciar atendimento
        await conn.query(
            "CALL sp_master_atendimento_iniciar(?, ?, ?, @id_atendimento, @sucesso, @mensagem)",
            [req.user.id_usuario, id_paciente, tipo_atendimento || "FFA"]
        );
        
        const [result] = await conn.query("SELECT @id_atendimento as id, @sucesso as sucesso, @mensagem as mensagem");
        
        if (result[0].sucesso) {
            res.json({ 
                sucesso: true, 
                atendimento: { id: result[0].id },
                mensagem: result[0].mensagem 
            });
        } else {
            res.status(400).json({ error: result[0].mensagem });
        }
        
    } catch (err) {
        console.error("Erro ao criar atendimento:", err);
        res.status(500).json({ error: "ERRO_AO_CRIAR_ATENDIMENTO" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/operacional/senhas
 * Gera nova senha
 * SP: sp_master_senha_emitir
 */
router.post("/senhas", authMiddleware, async (req, res) => {
    const { tipo, prioridade } = req.body;
    let conn;
    
    try {
        conn = await require("../config/database").getConnection();
        
        // Preparar payload JSON para a SP
        const payload = JSON.stringify({
            tipo: tipo || "CONSULTA",
            prioridade: prioridade || "NORMAL",
            id_unidade: req.user.id_unidade
        });
        
        // Chama a SP de emitir senha com parâmetros corretos
        // sp_master_senha_emitir(p_id_sessao, p_id_usuario, p_id_perfil, p_payload, OUT p_resultado, OUT p_sucesso, OUT p_mensagem)
        await conn.query(
            "CALL sp_master_senha_emitir(?, ?, ?, ?, @resultado, @sucesso, @mensagem)",
            [req.user.id_sessao_usuario, req.user.id_usuario, req.user.id_perfil, payload]
        );
        
        const [result] = await conn.query("SELECT @resultado as resultado, @sucesso as sucesso, @mensagem as mensagem");
        
        if (result[0].sucesso) {
            const dados = JSON.parse(result[0].resultado);
            res.json({ 
                sucesso: true, 
                senha: { 
                    id: dados.id_senha, 
                    numero: dados.numero_senha,
                    prefixo: dados.prefixo
                },
                mensagem: result[0].mensagem 
            });
        } else {
            res.status(400).json({ error: result[0].mensagem });
        }
        
    } catch (err) {
        console.error("Erro ao gerar senha:", err);
        res.status(500).json({ error: "ERRO_AO_GERAR_SENHA" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * GET /api/operacional/senhas
 * Lista senhas da unidade
 */
router.get("/senhas", authMiddleware, async (req, res) => {
    let conn;
    
    try {
        conn = await require("../config/database").getConnection();
        
        const [senhas] = await conn.query(
            "SELECT s.id_senha, s.numero, s.tipo, s.status, s.criado_em, p.nome as paciente_nome FROM senha s LEFT JOIN paciente p ON p.id = s.id_paciente WHERE s.id_unidade = ? ORDER BY s.criado_em DESC LIMIT 50",
            [req.user.id_unidade]
        );
        
        res.json({ senhas });
        
    } catch (err) {
        console.error("Erro ao buscar senhas:", err);
        res.status(500).json({ error: "ERRO_AO_BUSCAR_SENHAS" });
    } finally {
        if (conn) conn.release();
    }
});

// ======================================
// ROTAS DE FLUXO (já existentes)
// ======================================

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

// ======================================
// ROTAS DE ATENDIMENTOS (Triagem, Médico, Enfermagem)
// ======================================

/**
 * POST /api/operacional/atendimentos/chamar
 * Chama próximo paciente para atendimento
 */
router.post("/atendimentos/chamar", authMiddleware, async (req, res) => {
    const { tipo_local } = req.body;
    let conn;
    
    try {
        conn = await require("../config/database").getConnection();
        
        // Busca próximo paciente na fila
        const [paciente] = await conn.query(
            "SELECT id_fila, id_ffa, tipo, prioridade, substatus FROM fila_operacional WHERE id_unidade = ? AND substatus = 'AGUARDANDO' ORDER BY FIELD(prioridade, 'VERMELHO', 'LARANJA', 'AMARELO', 'VERDE', 'AZUL'), data_entrada ASC LIMIT 1",
            [req.user.id_unidade]
        );
        
        if (paciente.length === 0) {
            return res.status(404).json({ error: "NENHUM_PACIENTE_AGUARDANDO" });
        }
        
        // Atualiza status para CHAMADO
        await conn.query(
            "UPDATE fila_operacional SET substatus = 'EM_EXECUCAO', data_inicio = NOW() WHERE id_fila = ?",
            [paciente[0].id_fila]
        );
        
        // Busca dados completos do paciente via FFA
        const [pacienteCompleto] = await conn.query(
            "SELECT p.id_pessoa, p.nome, p.cpf, p.cns, p.data_nascimento FROM ffa f JOIN pessoa p ON p.id_pessoa = f.id_pessoa WHERE f.id_ffa = ?",
            [paciente[0].id_ffa]
        );
        
        res.json({ 
            sucesso: true, 
            atendimento: { 
                id: paciente[0].id_fila, 
                id_ffa: paciente[0].id_ffa,
                tipo: paciente[0].tipo,
                prioridade: paciente[0].prioridade,
                paciente: pacienteCompleto[0] || null 
            } 
        });
        
    } catch (err) {
        console.error("Erro ao chamar paciente:", err);
        res.status(500).json({ error: "ERRO_AO_CHAMAR_PACIENTE" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * PUT /api/operacional/atendimentos/:id
 * Atualiza atendimento (finaliza triagem, etc)
 */
router.put("/atendimentos/:id", authMiddleware, async (req, res) => {
    const { id } = req.params;
    const { status, prioridade, sinais_vitais, observacoes_triagem, acao } = req.body;
    let conn;
    
    try {
        conn = await require("../config/database").getConnection();
        
        if (acao === "FINALIZAR_TRIAGEM") {
            // Finaliza triagem e inicia atendimento médico
            await conn.query(
                "UPDATE fila_operacional SET status = 'EM_ATENDIMENTO', prioridade = ?, data_atendimento = NOW() WHERE id_fila = ?",
                [prioridade, id]
            );
            
            // Registra sinais vitais se fornecidos
            if (sinais_vitais) {
                // Aqui você pode inserir em uma tabela de sinais_vitais se existir
            }
            
            res.json({ sucesso: true, mensagem: "Triagem finalizada" });
        } else if (status) {
            // Atualiza status genérico
            await conn.query(
                "UPDATE fila_operacional SET status = ?, data_atendimento = NOW() WHERE id_fila = ?",
                [status, id]
            );
            
            res.json({ sucesso: true });
        } else {
            res.json({ sucesso: true });
        }
        
    } catch (err) {
        console.error("Erro ao atualizar atendimento:", err);
        res.status(500).json({ error: "ERRO_AO_ATUALIZAR_ATENDIMENTO" });
    } finally {
        if (conn) conn.release();
    }
});

/**
 * POST /api/operacional/atendimentos/:id/encaminhar
 * Encaminha paciente para outro local
 */
router.post("/atendimentos/:id/encaminhar", authMiddleware, async (req, res) => {
    const { id } = req.params;
    const { destino } = req.body;
    let conn;
    
    try {
        conn = await require("../config/database").getConnection();
        
        // Busca local operacional de destino
        let idLocalDestino = null;
        
        if (destino === "MEDICO") {
            // Busca consultório disponível
            const [consultorio] = await conn.query(
                "SELECT id_local_operacional FROM local_operacional WHERE tipo = 'CONSULTORIO' AND ativo = 1 LIMIT 1"
            );
            if (consultorio.length > 0) {
                idLocalDestino = consultorio[0].id_local_operacional;
            }
        }
        
        if (idLocalDestino) {
            await conn.query(
                "UPDATE fila_operacional SET id_local_operacional = ?, status = 'AGUARDANDO' WHERE id_fila = ?",
                [idLocalDestino, id]
            );
        } else {
            await conn.query(
                "UPDATE fila_operacional SET status = 'AGUARDANDO' WHERE id_fila = ?",
                [id]
            );
        }
        
        res.json({ sucesso: true, mensagem: "Paciente avançado" });
        
    } catch (err) {
        console.error("Erro ao avançar paciente:", err);
        res.status(500).json({ error: "ERRO_AO_AVANCAR_PACIENTE" });
    } finally {
        if (conn) conn.release();
    }
});

module.exports = router;
