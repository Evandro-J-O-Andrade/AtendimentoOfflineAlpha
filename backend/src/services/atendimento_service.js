/**
 * ================================================================
 * Atendimento Service
 * ================================================================
 * 
 * Serviço para operações de atendimento clínico.
 * Wrapper para chamadas ao kernel dispatcher.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const { dispatchKernel } = require("../kernel/dispatcher_gateway");

/**
 * Cria um novo atendimento
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} dados - Dados do atendimento
 * @returns {Promise<Object>}
 */
async function criarAtendimento(sessionContext, dados) {
    return await dispatchKernel({
        acao: 'ATENDIMENTO_CRIAR',
        contexto: 'ATENDIMENTO',
        payload: dados
    }, sessionContext);
}

/**
 * Busca atendimento por ID
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idAtendimento - ID do atendimento
 * @returns {Promise<Object>}
 */
async function buscarAtendimento(sessionContext, idAtendimento) {
    return await dispatchKernel({
        acao: 'ATENDIMENTO_BUSCAR',
        contexto: 'ATENDIMENTO',
        payload: { id_atendimento: idAtendimento }
    }, sessionContext);
}

/**
 * Atualiza status do atendimento
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idAtendimento - ID do atendimento
 * @param {string} novoStatus - Novo status
 * @returns {Promise<Object>}
 */
async function atualizarStatus(sessionContext, idAtendimento, novoStatus) {
    return await dispatchKernel({
        acao: 'ATENDIMENTO_ATUALIZAR_STATUS',
        contexto: 'ATENDIMENTO',
        payload: {
            id_atendimento: idAtendimento,
            status: novoStatus
        }
    }, sessionContext);
}

/**
 * Transiciona atendimento para próximo contexto
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idAtendimento - ID do atendimento
 * @param {string} contextoDestino - Contexto de destino
 * @returns {Promise<Object>}
 */
async function transicionarAtendimento(sessionContext, idAtendimento, contextoDestino) {
    return await dispatchKernel({
        acao: 'ATENDIMENTO_TRANSICIONAR',
        contexto: contextoDestino,
        payload: {
            id_atendimento: idAtendimento,
            destino: contextoDestino
        }
    }, sessionContext);
}

/**
 * Lista atendimentos por filtro
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} filtros - Filtros de busca
 * @returns {Promise<Object>}
 */
async function listarAtendimentos(sessionContext, filtros = {}) {
    return await dispatchKernel({
        acao: 'ATENDIMENTO_LISTAR',
        contexto: 'ATENDIMENTO',
        payload: filtros
    }, sessionContext);
}

/**
 * Finaliza atendimento
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idAtendimento - ID do atendimento
 * @param {Object} dadosEncerramento - Dados de encerramento
 * @returns {Promise<Object>}
 */
async function encerrarAtendimento(sessionContext, idAtendimento, dadosEncerramento) {
    return await dispatchKernel({
        acao: 'ATENDIMENTO_ENCERRAR',
        contexto: 'ATENDIMENTO',
        payload: {
            id_atendimento: idAtendimento,
            ...dadosEncerramento
        }
    }, sessionContext);
}

module.exports = {
    criarAtendimento,
    buscarAtendimento,
    atualizarStatus,
    transicionarAtendimento,
    listarAtendimentos,
    encerrarAtendimento
};
