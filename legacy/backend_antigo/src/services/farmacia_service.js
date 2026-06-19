/**
 * ================================================================
 * Farmácia Service
 * ================================================================
 * 
 * Serviço para operações de farmácia/dispensação.
 * Wrapper para chamadas ao kernel dispatcher.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const { dispatchKernel } = require("../kernel/dispatcher_gateway");

/**
 * Busca prescrições por termo
 * @param {Object} sessionContext - Contexto da sessão
 * @param {string} termo - Termo de busca (CPF, nome, senha)
 * @returns {Promise<Object>}
 */
async function buscarPrescricoes(sessionContext, termo) {
    return await dispatchKernel({
        acao: 'FARMACIA_BUSCAR_PRESCRICOES',
        contexto: 'FARMACIA',
        payload: { termo }
    }, sessionContext);
}

/**
 * Dispensar medicamento
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} dados - Dados da dispensação
 * @returns {Promise<Object>}
 */
async function dispensarMedicamento(sessionContext, dados) {
    return await dispatchKernel({
        acao: 'FARMACIA_DISPENSAR',
        contexto: 'FARMACIA',
        payload: dados
    }, sessionContext);
}

/**
 * Finaliza dispensação
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idDispensacao - ID da dispensação
 * @returns {Promise<Object>}
 */
async function finalizarDispensacao(sessionContext, idDispensacao) {
    return await dispatchKernel({
        acao: 'FARMACIA_FINALIZAR',
        contexto: 'FARMACIA',
        payload: { id_dispensacao: idDispensacao }
    }, sessionContext);
}

/**
 * Cancela dispensação
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idDispensacao - ID da dispensação
 * @param {string} motivo - Motivo do cancelamento
 * @returns {Promise<Object>}
 */
async function cancelarDispensacao(sessionContext, idDispensacao, motivo) {
    return await dispatchKernel({
        acao: 'FARMACIA_CANCELAR',
        contexto: 'FARMACIA',
        payload: { id_dispensacao: idDispensacao, motivo }
    }, sessionContext);
}

/**
 * Busca histórico de dispensação
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} filtros - Filtros de busca
 * @returns {Promise<Object>}
 */
async function buscarHistorico(sessionContext, filtros = {}) {
    return await dispatchKernel({
        acao: 'FARMACIA_HISTORICO',
        contexto: 'FARMACIA',
        payload: filtros
    }, sessionContext);
}

/**
 * Lista medicamentos em estoque
 * @param {Object} sessionContext - Contexto da sessão
 * @returns {Promise<Object>}
 */
async function listarEstoque(sessionContext) {
    return await dispatchKernel({
        acao: 'FARMACIA_LISTAR_ESTOQUE',
        contexto: 'FARMACIA',
        payload: {}
    }, sessionContext);
}

/**
 * Atualiza estoque de medicamento
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} dados - Dados do estoque
 * @returns {Promise<Object>}
 */
async function atualizarEstoque(sessionContext, dados) {
    return await dispatchKernel({
        acao: 'FARMACIA_ATUALIZAR_ESTOQUE',
        contexto: 'FARMACIA',
        payload: dados
    }, sessionContext);
}

/**
 * Lista pacientes aguardando farmácia
 * @param {Object} sessionContext - Contexto da sessão
 * @returns {Promise<Object>}
 */
async function listarEsperaFarmacia(sessionContext) {
    return await dispatchKernel({
        acao: 'FARMACIA_LISTAR_ESPERA',
        contexto: 'FARMACIA',
        payload: {}
    }, sessionContext);
}

module.exports = {
    buscarPrescricoes,
    dispensarMedicamento,
    finalizarDispensacao,
    cancelarDispensacao,
    buscarHistorico,
    listarEstoque,
    atualizarEstoque,
    listarEsperaFarmacia
};
