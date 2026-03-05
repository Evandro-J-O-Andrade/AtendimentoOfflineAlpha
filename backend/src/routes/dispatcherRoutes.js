const express = require("express");
const router = express.Router();
const db = require("../config/database");

/**
 * =====================================
 * Master Dispatcher Runtime
 * Ponto único de entrada para todas as ações
 * =====================================
 * 
 * Payload esperado:
 * {
 *   "acao": "ATENDIMENTO_TRANSICIONAR",
 *   "contexto": "MEDICO",
 *   "payload": {
 *     "id_atendimento": 123,
 *     "status": "AGUARDANDO_FARMACIA"
 *   }
 * }
 */

// Middleware para validar sessão
const validarSessao = async (req, res, next) => {
    try {
        if (!req.user || !req.user.id_sessao_usuario) {
            return res.status(401).json({
                sucesso: false,
                mensagem: "Sessão inválida"
            });
        }
        next();
    } catch (error) {
        return res.status(401).json({
            sucesso: false,
            mensagem: "Erro na validação da sessão"
        });
    }
};

/**
 * POST /api/runtime/dispatch
 * Endpoint central para todas as ações do sistema
 */
router.post("/dispatch", validarSessao, async (req, res) => {
    const connection = await db.getConnection();
    
    try {
        const { acao, contexto, payload } = req.body;
        
        // Validar parâmetros obrigatórios
        if (!acao) {
            return res.status(400).json({
                sucesso: false,
                mensagem: "Ação é obrigatória"
            });
        }

        // Validar tamanho do payload (limite de 1MB)
        const MAX_PAYLOAD_SIZE = 1024 * 1024; // 1MB
        const payloadJson = JSON.stringify(payload || {});
        if (payloadJson.length > MAX_PAYLOAD_SIZE) {
            return res.status(400).json({
                sucesso: false,
                mensagem: "Payload muito grande (máximo 1MB)"
            });
        }

        // Chamar a stored procedure
        const [results] = await connection.query(
            `CALL sp_master_dispatcher_runtime(?, ?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
            [id_sessao, id_usuario, id_perfil, acao, contexto || 'DEFAULT', payloadJson]
        );

        // Obter os parâmetros de saída
        const [[output]] = await connection.query(
            `SELECT @resultado as resultado, @sucesso as sucesso, @mensagem as mensagem`
        );

        // Formatar resposta
        const response = {
            sucesso: output.sucesso === 1 || output.sucesso === true,
            mensagem: output.mensagem,
            dados: output.resultado ? JSON.parse(output.resultado) : null
        };

        return res.json(response);

    } catch (error) {
        console.error("Erro no dispatcher:", error);
        
        return res.status(500).json({
            sucesso: false,
            mensagem: "Erro interno no dispatcher",
            erro: error.message
        });
    } finally {
        connection.release();
    }
});

/**
 * POST /api/runtime/dispatch/batch
 * Executar múltiplas ações em uma única transação
 */
router.post("/dispatch/batch", validarSessao, async (req, res) => {
    const connection = await db.getConnection();
    
    try {
        const { acoes } = req.body;
        
        if (!acoes || !Array.isArray(acoes) || acoes.length === 0) {
            return res.status(400).json({
                sucesso: false,
                mensagem: "Array de ações é obrigatório"
            });
        }

        const resultados = [];
        
        await connection.beginTransaction();

        for (const item of acoes) {
            const { acao, contexto, payload } = item;
            
            if (!acao) {
                throw new Error("Ação é obrigatória em uma das operações");
            }

            const id_sessao = req.user.id_sessao_usuario;
            const id_usuario = req.user.id_usuario;
            const id_perfil = req.user.id_perfil;
            const payloadJson = JSON.stringify(payload || {});

            await connection.query(
                `CALL sp_master_dispatcher_runtime(?, ?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
                [id_sessao, id_usuario, id_perfil, acao, contexto || 'DEFAULT', payloadJson]
            );

            const [[output]] = await connection.query(
                `SELECT @resultado as resultado, @sucesso as sucesso, @mensagem as mensagem`
            );

            resultados.push({
                acao,
                sucesso: output.sucesso === 1 || output.sucesso === true,
                mensagem: output.mensagem,
                dados: output.resultado ? JSON.parse(output.resultado) : null
            });
        }

        await connection.commit();

        // Verificar se todas as operações tiveram sucesso
        const todasSucesso = resultados.every(r => r.sucesso);

        return res.json({
            sucesso: todasSucesso,
            mensagem: todasSucesso 
                ? "Todas as operações executadas com sucesso" 
                : "Algumas operações falharam",
            resultados
        });

    } catch (error) {
        await connection.rollback();
        console.error("Erro no dispatcher batch:", error);
        
        return res.status(500).json({
            sucesso: false,
            mensagem: "Erro ao executar operações em lote",
            erro: error.message
        });
    } finally {
        connection.release();
    }
});

/**
 * GET /api/runtime/dispatch/acao/list
 * Lista todas as ações disponíveis para o perfil atual
 */
router.get("/dispatch/acao/list", validarSessao, async (req, res) => {
    try {
        const id_perfil = req.user.id_perfil;

        // Buscar ações permitidas para o perfil
        const [acoes] = await db.execute(`
            SELECT DISTINCT 
                CONCAT(fs_origem.codigo, '_', fs_destino.codigo) as acao_codigo,
                fs_origem.descricao as acao_descricao,
                ft.id_perfil_requerido
            FROM fluxo_transicao ft
            JOIN fluxo_status fs_origem ON fs_origem.id_fluxo_status = ft.id_status_origem
            JOIN fluxo_status fs_destino ON fs_destino.id_fluxo_status = ft.id_status_destino
            WHERE ft.id_perfil_requerido = ?
              AND ft.ativo = 1
            ORDER BY fs_origem.codigo, fs_destino.codigo
        `, [id_perfil]);

        // Lista de ações simplificada
        const acoesSimplificadas = [
            { codigo: 'SESSION_HEARTBEAT', descricao: 'Manter sessão ativa', contexto: 'SESSION' },
            { codigo: 'ATENDIMENTO_INICIAR', descricao: 'Iniciar atendimento', contexto: 'ATENDIMENTO' },
            { codigo: 'ATENDIMENTO_TRANSICIONAR', descricao: 'Transicionar atendimento', contexto: 'ATENDIMENTO' },
            { codigo: 'SENHA_CRIAR', descricao: 'Criar nova senha', contexto: 'SENHA' },
            { codigo: 'SENHA_CHAMAR', descricao: 'Chamar senha', contexto: 'SENHA' },
            { codigo: 'SENHA_ATENDER', descricao: 'Atender senha', contexto: 'SENHA' },
            { codigo: 'TRIAGEM_REGISTRAR', descricao: 'Registrar triagem', contexto: 'TRIAGEM' },
            { codigo: 'PRESCRICAO_CRIAR', descricao: 'Criar prescrição', contexto: 'PRESCRICAO' },
            { codigo: 'FARMACIA_DISPENSAR', descricao: 'Dispensar medicamento', contexto: 'FARMACIA' },
            { codigo: 'ENFERMAGEM_REGISTRAR', descricao: 'Registrar procedimento', contexto: 'ENFERMAGEM' },
        ];

        // Mesclar com ações do banco
        const todasAcoes = acoesSimplificadas.map(a => ({
            ...a,
            permitida: acoes.some(b => b.acao_codigo.includes(a.codigo))
        }));

        return res.json({
            sucesso: true,
            acoes: todasAcoes
        });

    } catch (error) {
        console.error("Erro ao listar ações:", error);
        return res.status(500).json({
            sucesso: false,
            mensagem: "Erro ao listar ações disponíveis"
        });
    }
});

/**
 * GET /api/runtime/ledger/:uuid
 * Buscar evento específico no ledger
 */
router.get("/ledger/:uuid", validarSessao, async (req, res) => {
    try {
        const { uuid } = req.params;

        const [eventos] = await db.execute(`
            SELECT * FROM atendimento_evento_ledger 
            WHERE uuid_transacao = ?
            ORDER BY created_at ASC
        `, [uuid]);

        return res.json({
            sucesso: true,
            eventos
        });

    } catch (error) {
        console.error("Erro ao buscar ledger:", error);
        return res.status(500).json({
            sucesso: false,
            mensagem: "Erro ao buscar eventos"
        });
    }
});

/**
 * GET /api/runtime/ledger/usuario/:id
 * Buscar eventos do usuário
 */
router.get("/ledger/usuario/:id", validarSessao, async (req, res) => {
    try {
        const { id } = req.params;
        const limite = parseInt(req.query.limite) || 50;

        const [eventos] = await db.execute(`
            SELECT * FROM atendimento_evento_ledger 
            WHERE id_usuario = ?
            ORDER BY created_at DESC
            LIMIT ?
        `, [id, limite]);

        return res.json({
            sucesso: true,
            eventos
        });

    } catch (error) {
        console.error("Erro ao buscar ledger:", error);
        return res.status(500).json({
            sucesso: false,
            mensagem: "Erro ao buscar eventos"
        });
    }
});

module.exports = router;
