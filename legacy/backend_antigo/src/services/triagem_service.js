/**
 * ================================================================
 * Triagem Service
 * ================================================================
 * 
 * Serviço para operações de triagem clínica.
 * Wrapper para chamadas ao kernel dispatcher.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const { dispatchKernel } = require("../kernel/dispatcher_gateway");

/**
 * Inicia triagem de um atendimento
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} dados - Dados da triagem
 * @returns {Promise<Object>}
 */
async function iniciarTriagem(sessionContext, dados) {
    return await dispatchKernel({
        acao: 'TRIAGEM_INICIAR',
        contexto: 'TRIAGEM',
        payload: dados
    }, sessionContext);
}

/**
 * Registra sinais vitais
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} sinais - Sinais vitais
 * @returns {Promise<Object>}
 */
async function registrarSinaisVitais(sessionContext, sinais) {
    return await dispatchKernel({
        acao: 'TRIAGEM_SINAIS_VITAIS',
        contexto: 'TRIAGEM',
        payload: sinais
    }, sessionContext);
}

/**
 * Classifica risco do paciente
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} dados - Dados da classificação
 * @returns {Promise<Object>}
 */
async function classificarRisco(sessionContext, dados) {
    return await dispatchKernel({
        acao: 'TRIAGEM_CLASSIFICAR_RISCO',
        contexto: 'TRIAGEM',
        payload: dados
    }, sessionContext);
}

/**
 * Finaliza triagem
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idAtendimento - ID do atendimento
 * @returns {Promise<Object>}
 */
async function finalizarTriagem(sessionContext, idAtendimento) {
    return await dispatchKernel({
        acao: 'TRIAGEM_FINALIZAR',
        contexto: 'TRIAGEM',
        payload: { id_atendimento: idAtendimento }
    }, sessionContext);
}

/**
 * Lista pacientes em espera de triagem
 * @param {Object} sessionContext - Contexto da sessão
 * @returns {Promise<Object>}
 */
async function listarEsperaTriagem(sessionContext) {
    return await dispatchKernel({
        acao: 'TRIAGEM_LISTAR_ESPERA',
        contexto: 'TRIAGEM',
        payload: {}
    }, sessionContext);
}

/**
 * Atualiza observações da triagem
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} dados - Observações
 * @returns {Promise<Object>}
 */
async function atualizarObservacoes(sessionContext, dados) {
    return await dispatchKernel({
        acao: 'TRIAGEM_OBSERVACOES',
        contexto: 'TRIAGEM',
        payload: dados
    }, sessionContext);
}

/**
 * Registra histórico de alergias
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} dados - Dados das alergias
 * @returns {Promise<Object>}
 */
async function registrarAlergias(sessionContext, dados) {
    return await dispatchKernel({
        acao: 'TRIAGEM_ALERGIAS',
        contexto: 'TRIAGEM',
        payload: dados
    }, sessionContext);
}

module.exports = {
    iniciarTriagem,
    registrarSinaisVitais,
    classificarRisco,
    finalizarTriagem,
    listarEsperaTriagem,
    atualizarObservacoes,
    registrarAlergias
};
