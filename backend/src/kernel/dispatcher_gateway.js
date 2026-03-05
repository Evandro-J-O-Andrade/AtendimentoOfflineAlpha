/**
 * ================================================================
 * Kernel Dispatcher Gateway
 * ================================================================
 * 
 * Ponto central de entrada para todas as operações do sistema.
 * Conecta Frontend → Backend → Stored Procedure Kernel
 * 
 * Fluxo:
 * React → API Gateway → dispatcher_gateway.js → sp_dispatcher_kernel
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const pool = require("../config/database");
const { v4: uuidv4 } = require("uuid");

/**
 * Dispatch principal - executa ação no kernel
 * @param {Object} payload - Payload contendo acao, contexto, payload
 * @param {Object} sessionContext - Contexto da sessão (req.user)
 * @returns {Promise<Object>} Resultado da operação
 */
async function dispatchKernel(payload, sessionContext) {
    const {
        acao,
        contexto = "DEFAULT",
        payload: actionPayload = {}
    } = payload;

    if (!acao) {
        throw new Error("ACAO_OBRIGATORIA");
    }

    const connection = await pool.getConnection();

    try {
        await connection.beginTransaction();

        const id_sessao = sessionContext.id_sessao_usuario;
        const id_usuario = sessionContext.id_usuario;
        const id_perfil = sessionContext.id_perfil;
        const id_tenant = sessionContext.id_entidade || 1;

        // Converter payload para JSON string
        const payloadJson = JSON.stringify(actionPayload);

        // Gerar UUID da transação
        const transaction_id = uuidv4();

        // Log inicial no ledger
        await connection.execute(
            `INSERT INTO runtime_execution_queue 
             (id, id_sessao, id_usuario, id_perfil, acao, contexto, payload, status, criado_em)
             VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDENTE', NOW())`,
            [transaction_id, id_sessao, id_usuario, id_perfil, acao, contexto, payloadJson]
        );

        // Chamar procedure do kernel
        const [results] = await connection.query(
            `CALL sp_dispatcher_kernel(?, ?, ?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
            [id_sessao, id_usuario, id_perfil, acao, contexto, payloadJson, transaction_id]
        );

        // Obter parâmetros de saída
        const [[output]] = await connection.query(
            `SELECT @resultado as resultado, @sucesso as sucesso, @mensagem as mensagem`
        );

        // Atualizar status na fila
        const status = (output.sucesso === 1 || output.sucesso === true) ? "CONCLUIDO" : "ERRO";
        await connection.execute(
            `UPDATE runtime_execution_queue SET status = ?, atualizado_em = NOW() WHERE id = ?`,
            [status, transaction_id]
        );

        await connection.commit();

        // Formatar resposta
        return {
            sucesso: output.sucesso === 1 || output.sucesso === true,
            mensagem: output.mensagem,
            dados: output.resultado ? JSON.parse(output.resultado) : null,
            transaction_id
        };

    } catch (error) {
        await connection.rollback();
        
        // Log de erro
        console.error("[dispatcher_gateway] Erro:", error.message);
        
        throw error;
    } finally {
        connection.release();
    }
}

/**
 * Dispatch em lote - executa múltiplas ações em uma transação
 * @param {Array} acoes - Array de ações para executar
 * @param {Object} sessionContext - Contexto da sessão
 * @returns {Promise<Array>} Array de resultados
 */
async function dispatchKernelBatch(acoes, sessionContext) {
    if (!Array.isArray(acoes) || acoes.length === 0) {
        throw new Error("ARRAY_ACOES_OBRIGATORIO");
    }

    const connection = await pool.getConnection();
    const resultados = [];

    try {
        await connection.beginTransaction();

        for (const acao of acoes) {
            const resultado = await dispatchKernel(acao, sessionContext);
            resultados.push(resultado);
        }

        await connection.commit();
        return resultados;

    } catch (error) {
        await connection.rollback();
        throw error;
    } finally {
        connection.release();
    }
}

/**
 * Valida se o usuário tem permissão para a ação
 * @param {number} id_perfil - ID do perfil do usuário
 * @param {string} acao - Ação a ser executada
 * @param {string} contexto - Contexto operacional
 * @returns {Promise<boolean>}
 */
async function validarPermissao(id_perfil, acao, contexto) {
    // Admin sempre tem permissão
    if (id_perfil === 1) {
        return true;
    }

    const connection = await pool.getConnection();
    
    try {
        // Verificar se tabela existe
        const [tables] = await connection.query(
            "SHOW TABLES LIKE 'perfil_permissao'"
        );

        if (tables.length === 0) {
            console.warn("[dispatcher_gateway] Tabela perfil_permissao não existe");
            return true; // Em dev, permitir
        }

        // Verificar permissão
        const [permissoes] = await connection.query(
            `SELECT COUNT(*) as tem_permissao
             FROM perfil_permissao pp
             JOIN permissao p ON p.id_permissao = pp.id_permissao
             WHERE pp.id_perfil = ? AND p.codigo = ?`,
            [id_perfil, `${acao}_*`]
        );

        return permissoes[0].tem_permissao > 0;

    } finally {
        connection.release();
    }
}

/**
 *.healthCheck - Verifica saúde do dispatcher
 */
async function healthCheck() {
    const connection = await pool.getConnection();
    
    try {
        // Testar conexão
        await connection.ping();
        
        // Verificar procedures necessárias
        const [procs] = await connection.query(
            `SHOW PROCEDURE STATUS WHERE Db = DATABASE() AND Name LIKE '%dispatcher%'`
        );
        
        return {
            status: "HEALTHY",
            procedures: procs.length,
            timestamp: new Date().toISOString()
        };
    } catch (error) {
        return {
            status: "UNHEALTHY",
            error: error.message,
            timestamp: new Date().toISOString()
        };
    } finally {
        connection.release();
    }
}

module.exports = {
    dispatchKernel,
    dispatchKernelBatch,
    validarPermissao,
    healthCheck
};
