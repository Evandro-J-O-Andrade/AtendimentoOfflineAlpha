const express = require("express");
const router = express.Router();
const db = require("../config/database");

/**
 * =====================================
 * Master Dispatcher Runtime
 * Ponto único de entrada para todas as ações
 * =====================================
 * 
 * MAPA DE AÇÕES -> SPs:
 * - ATENDIMENTO_INICIAR -> sp_master_atendimento_iniciar
 * - ATENDIMENTO_TRANSICIONAR -> sp_master_atendimento_transicionar
 * - ATENDIMENTO_FINALIZAR -> sp_master_atendimento_finalizar
 * - ATENDIMENTO_CANCELAR -> sp_master_atendimento_cancelar
 * - PACIENTE_ATUALIZAR -> sp_master_atualizar_paciente
 * - ATENDIMENTO_VINCULAR_PACIENTE -> sp_master_vincular_atendimento_paciente
 * - ADMINISTRACAO_MEDICACAO -> sp_master_registrar_administracao_medicacao
 * - CANCELAR_ADMINISTRACAO_MEDICACAO -> sp_master_cancelar_administracao_medicacao
 * - REGISTRAR_ALERTA -> sp_master_registrar_alerta
 * - AGENDA_DISPONIBILIDADE -> sp_master_agenda_disponibilidade
 * - ALERTA_CONSUMO -> sp_master_alerta_consumo
 * - ADMINISTRACAO_MEDICACAO_ORDEM -> sp_master_administracao_medicacao_ordem
 * - AGENDAMENTO_EVENTO -> sp_master_agendamento_eventos
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

// Mapeamento de ações para Stored Procedures
const ACAO_SP_MAP = {
    // Atendimento
    'ATENDIMENTO_INICIAR': 'sp_master_atendimento_iniciar',
    'ATENDIMENTO_TRANSICIONAR': 'sp_master_atendimento_transicionar',
    'ATENDIMENTO_FINALIZAR': 'sp_master_atendimento_finalizar',
    'ATENDIMENTO_CANCELAR': 'sp_master_atendimento_cancelar',
    
    // Paciente
    'PACIENTE_ATUALIZAR': 'sp_master_atualizar_paciente',
    'ATENDIMENTO_VINCULAR_PACIENTE': 'sp_master_vincular_atendimento_paciente',
    
    // Senha
    'TOTEM_GERAR_SENHA': 'sp_totem_gerar_senha',
    'SENHA_EMITIR': 'sp_master_senha_emitir',
    'SENHA_RECEPCAO': 'sp_master_senha_recepcao',
    'CHAMAR_SENHA': 'sp_master_chamar_senha',
    'SENHA_CRIAR': 'sp_master_dispatcher_runtime',
    'SENHA_CHAMAR': 'sp_master_dispatcher_runtime',
    'SENHA_ATENDER': 'sp_master_dispatcher_runtime',
    'COMPLEMENTAR_SENHA': 'sp_complementar_senha',
    'CANCELAR_SENHA': 'sp_painel_cancelar_senha',
    'SENHA_INSERIR': 'sp_painel_inserir_senha',
    
    // Triagem
    'TRIAGEM_CLASSIFICAR': 'sp_triagem_classificar_senha',
    'TRIAGEM_REGISTRAR': 'sp_master_dispatcher_runtime',
    
    // FFA (Prontuário)
    'FFA_CRIAR': 'sp_ffa_criar',
    'FFA_ADICIONAR_ITEM': 'sp_ffa_adicionar_item',
    
    // Medicação
    'ADMINISTRACAO_MEDICACAO_REGISTRAR': 'sp_master_registrar_administracao_medicacao',
    'ADMINISTRACAO_MEDICACAO': 'sp_master_registrar_administracao_medicacao',
    'CANCELAR_ADMINISTRACAO_MEDICACAO': 'sp_master_cancelar_administracao_medicacao',
    'ADMINISTRACAO_MEDICACAO_ORDEM': 'sp_master_administracao_medicacao_ordem',
    
    // Alertas
    'REGISTRAR_ALERTA': 'sp_master_registrar_alerta',
    'ALERTA_REGISTRAR': 'sp_master_registrar_alerta',
    'ALERTA_CONSUMO': 'sp_master_alerta_consumo',
    
    // Agenda
    'AGENDA_DISPONIBILIDADE_CRIAR': 'sp_master_agenda_disponibilidade',
    'AGENDA_DISPONIBILIDADE': 'sp_master_agenda_disponibilidade',
    'AGENDAMENTO_EVENTO_CRIAR': 'sp_master_agendamento_eventos',
    'AGENDAMENTO_EVENTO': 'sp_master_agendamento_eventos',
    
    // Padrão (dispatcher central)
    'SESSION_HEARTBEAT': 'sp_master_dispatcher_runtime',
    'PRESCRICAO_CRIAR': 'sp_master_dispatcher_runtime',
    'FARMACIA_DISPENSAR': 'sp_master_dispatcher_runtime',
    'ENFERMAGEM_REGISTRAR': 'sp_master_dispatcher_runtime'
};

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
 * Executa a SP correta com base na ação
 */
router.post("/dispatch", validarSessao, async (req, res) => {
    const connection = await db.getConnection();
    
    try {
        const { acao, contexto, payload } = req.body;
        const id_sessao = req.user.id_sessao_usuario;
        const id_usuario = req.user.id_usuario;
        const id_perfil = req.user.id_perfil;
        
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

        // Determinar qual SP chamar
        const storedProcedure = ACAO_SP_MAP[acao] || 'sp_master_dispatcher_runtime';
        
        console.log(`[dispatcher] Executando ${storedProcedure} para ação ${acao}`);

        // Chamar a stored procedure
        await connection.query(
            `CALL ${storedProcedure}(?, ?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
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

        // Lista completa de ações disponíveis mapeadas para SPs
        const acoesSimplificadas = [
            // Sessão
            { codigo: 'SESSION_HEARTBEAT', descricao: 'Manter sessão ativa', contexto: 'SESSION', sp: 'sp_master_dispatcher_runtime' },
            
            // Atendimento
            { codigo: 'ATENDIMENTO_INICIAR', descricao: 'Iniciar atendimento', contexto: 'ATENDIMENTO', sp: 'sp_master_atendimento_iniciar' },
            { codigo: 'ATENDIMENTO_TRANSICIONAR', descricao: 'Transicionar atendimento', contexto: 'ATENDIMENTO', sp: 'sp_master_atendimento_transicionar' },
            { codigo: 'ATENDIMENTO_FINALIZAR', descricao: 'Finalizar atendimento', contexto: 'ATENDIMENTO', sp: 'sp_master_atendimento_finalizar' },
            { codigo: 'ATENDIMENTO_CANCELAR', descricao: 'Cancelar atendimento', contexto: 'ATENDIMENTO', sp: 'sp_master_atendimento_cancelar' },
            { codigo: 'ATENDIMENTO_VINCULAR_PACIENTE', descricao: 'Vincular paciente ao atendimento', contexto: 'ATENDIMENTO', sp: 'sp_master_vincular_atendimento_paciente' },
            
            // Paciente
            { codigo: 'PACIENTE_ATUALIZAR', descricao: 'Atualizar dados do paciente', contexto: 'PACIENTE', sp: 'sp_master_atualizar_paciente' },
            
            // Senha/Totem
            { codigo: 'TOTEM_GERAR_SENHA', descricao: 'Gerar senha (Totem)', contexto: 'SENHA', sp: 'sp_totem_gerar_senha' },
            { codigo: 'SENHA_EMITIR', descricao: 'Emitir senha (Totem)', contexto: 'SENHA', sp: 'sp_master_senha_emitir' },
            { codigo: 'SENHA_RECEPCAO', descricao: 'Senha recepção/guichê', contexto: 'SENHA', sp: 'sp_master_senha_recepcao' },
            { codigo: 'CHAMAR_SENHA', descricao: 'Chamar/Cancelar senha', contexto: 'SENHA', sp: 'sp_master_chamar_senha' },
            { codigo: 'COMPLEMENTAR_SENHA', descricao: 'Complementar senha', contexto: 'SENHA', sp: 'sp_complementar_senha' },
            { codigo: 'CANCELAR_SENHA', descricao: 'Cancelar senha', contexto: 'SENHA', sp: 'sp_painel_cancelar_senha' },
            { codigo: 'SENHA_INSERIR', descricao: 'Inserir senha no painel', contexto: 'SENHA', sp: 'sp_painel_inserir_senha' },
            { codigo: 'SENHA_CRIAR', descricao: 'Criar nova senha', contexto: 'SENHA', sp: 'sp_master_dispatcher_runtime' },
            { codigo: 'SENHA_CHAMAR', descricao: 'Chamar senha', contexto: 'SENHA', sp: 'sp_master_dispatcher_runtime' },
            { codigo: 'SENHA_ATENDER', descricao: 'Atender senha', contexto: 'SENHA', sp: 'sp_master_dispatcher_runtime' },
            
            // Triagem
            { codigo: 'TRIAGEM_CLASSIFICAR', descricao: 'Classificar senha (Manchester)', contexto: 'TRIAGEM', sp: 'sp_triagem_classificar_senha' },
            { codigo: 'TRIAGEM_REGISTRAR', descricao: 'Registrar triagem', contexto: 'TRIAGEM', sp: 'sp_master_dispatcher_runtime' },
            
            // FFA (Prontuário)
            { codigo: 'FFA_CRIAR', descricao: 'Criar FFA/Prontuário', contexto: 'FFA', sp: 'sp_ffa_criar' },
            { codigo: 'FFA_ADICIONAR_ITEM', descricao: 'Adicionar item na FFA', contexto: 'FFA', sp: 'sp_ffa_adicionar_item' },
            
            // Prescrição
            { codigo: 'PRESCRICAO_CRIAR', descricao: 'Criar prescrição', contexto: 'PRESCRICAO', sp: 'sp_master_dispatcher_runtime' },
            
            // Farmácia
            { codigo: 'FARMACIA_DISPENSAR', descricao: 'Dispensar medicamento', contexto: 'FARMACIA', sp: 'sp_master_dispatcher_runtime' },
            { codigo: 'ADMINISTRACAO_MEDICACAO_REGISTRAR', descricao: 'Registrar administração de medicação', contexto: 'FARMACIA', sp: 'sp_master_registrar_administracao_medicacao' },
            { codigo: 'ADMINISTRACAO_MEDICACAO_ORDEM', descricao: 'Criar ordem de medicação', contexto: 'FARMACIA', sp: 'sp_master_administracao_medicacao_ordem' },
            { codigo: 'CANCELAR_ADMINISTRACAO_MEDICACAO', descricao: 'Cancelar administração', contexto: 'FARMACIA', sp: 'sp_master_cancelar_administracao_medicacao' },
            
            // Enfermagem
            { codigo: 'ENFERMAGEM_REGISTRAR', descricao: 'Registrar procedimento', contexto: 'ENFERMAGEM', sp: 'sp_master_dispatcher_runtime' },
            
            // Alertas
            { codigo: 'REGISTRAR_ALERTA', descricao: 'Registrar alerta', contexto: 'ALERTA', sp: 'sp_master_registrar_alerta' },
            { codigo: 'ALERTA_CONSUMO', descricao: 'Alerta de consumo', contexto: 'ALERTA', sp: 'sp_master_alerta_consumo' },
            
            // Agenda
            { codigo: 'AGENDA_DISPONIBILIDADE_CRIAR', descricao: 'Criar disponibilidade na agenda', contexto: 'AGENDA', sp: 'sp_master_agenda_disponibilidade' },
            { codigo: 'AGENDAMENTO_EVENTO_CRIAR', descricao: 'Criar evento de agendamento', contexto: 'AGENDA', sp: 'sp_master_agendamento_eventos' }
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
