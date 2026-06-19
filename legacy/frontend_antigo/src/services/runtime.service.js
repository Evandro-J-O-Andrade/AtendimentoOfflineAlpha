import api from './api';

/**
 * Serviço central de execução de ações (Novo Modelo)
 * Baseado no item 2.5 do ARQUITETURA_SISTEMA_ANALISE.md
 */
export const runtimeService = {
    /**
     * Despacha uma ação semântica para o Dispatcher Central do Backend
     * @param {string} acao - Ex: 'TRIAGEM_FINALIZAR', 'SENHA_EMITIR'
     * @param {object} payload - Dados da transação
     * @param {object} runtime - Contexto (Unidade, Local, etc)
     */
    dispatch: async (acao, payload, runtime) => {
        const envelope = {
            acao,
            contexto: {
                id_saas_entidade: runtime.id_saas_entidade,
                id_unidade: runtime.id_unidade,
                id_local_operacional: runtime.id_local_operacional,
                id_perfil: runtime.id_perfil
            },
            payload,
            timestamp: new Date().toISOString()
        };

        return api.post('/runtime/dispatch', envelope);
    }
};