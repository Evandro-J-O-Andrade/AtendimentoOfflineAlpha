/**
 * ================================================================
 * Senha Service
 * ================================================================
 * 
 * Serviço para operações de senha/ticket de atendimento.
 * Wrapper para chamadas ao kernel dispatcher.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const { dispatchKernel } = require("../kernel/dispatcher_gateway");

/**
 * Gera uma nova senha
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} dados - Dados para geração da senha
 * @returns {Promise<Object>}
 */
async function gerarSenha(sessionContext, dados) {
    return await dispatchKernel({
        acao: 'SENHA_GERAR',
        contexto: 'RECEPCAO',
        payload: dados
    }, sessionContext);
}

/**
 * Chama próxima senha
 * @param {Object} sessionContext - Contexto da sessão
 * @param {Object} dados - Dados para chamar senha
 * @returns {Promise<Object>}
 */
async function chamarSenha(sessionContext, dados) {
    return await dispatchKernel({
        acao: 'SENHA_CHAMAR',
        contexto: 'RECEPCAO',
        payload: dados
    }, sessionContext);
}

/**
 * Atende uma senha
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idSenha - ID da senha
 * @returns {Promise<Object>}
 */
async function atenderSenha(sessionContext, idSenha) {
    return await dispatchKernel({
        acao: 'SENHA_ATENDER',
        contexto: 'ATENDIMENTO',
        payload: { id_senha: idSenha }
    }, sessionContext);
}

/**
 * Cancela uma senha
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idSenha - ID da senha
 * @param {string} motivo - Motivo do cancelamento
 * @returns {Promise<Object>}
 */
async function cancelarSenha(sessionContext, idSenha, motivo) {
    return await dispatchKernel({
        acao: 'SENHA_CANCELAR',
        contexto: 'RECEPCAO',
        payload: { id_senha: idSenha, motivo }
    }, sessionContext);
}

/**
 * Lista senhas por status
 * @param {Object} sessionContext - Contexto da sessão
 * @param {string} status - Status da senha
 * @returns {Promise<Object>}
 */
async function listarSenhas(sessionContext, status = 'AGUARDANDO') {
    return await dispatchKernel({
        acao: 'SENHA_LISTAR',
        contexto: 'RECEPCAO',
        payload: { status }
    }, sessionContext);
}

/**
 * Reordena senha na fila
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idSenha - ID da senha
 * @param {number} novaPosicao - Nova posição na fila
 * @returns {Promise<Object>}
 */
async function reordenarSenha(sessionContext, idSenha, novaPosicao) {
    return await dispatchKernel({
        acao: 'SENHA_REORDENAR',
        contexto: 'RECEPCAO',
        payload: { id_senha: idSenha, posicao: novaPosicao }
    }, sessionContext);
}

/**
 * Transfere senha para outro local
 * @param {Object} sessionContext - Contexto da sessão
 * @param {number} idSenha - ID da senha
 * @param {number} idLocalDestino - ID do local de destino
 * @returns {Promise<Object>}
 */
async function transferirSenha(sessionContext, idSenha, idLocalDestino) {
    return await dispatchKernel({
        acao: 'SENHA_TRANSFERIR',
        contexto: 'RECEPCAO',
        payload: { id_senha: idSenha, id_local: idLocalDestino }
    }, sessionContext);
}

module.exports = {
    gerarSenha,
    chamarSenha,
    atenderSenha,
    cancelarSenha,
    listarSenhas,
    reordenarSenha,
    transferirSenha
};
