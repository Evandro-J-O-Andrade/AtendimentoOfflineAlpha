/**
 * SP API - Cliente universal para Stored Procedures
 * HIS/PA - Sistema de Prontuário Ambulatorial
 * 
 * Modelo Canônico:
 * {
 *   "metodo": "GET | SET | POST | REQUEST",
 *   "rota": "AUTH.LOGIN | AUTH.CONTEXTO_GET | MODULO.ACAO",
 *   "id_sessao": 123,
 *   "payload": { ... }
 * }
 * 
 * Padrão: Backend = executor, Banco = cérebro
 */

const API_URL = '/api/sp';

/**
 * Chama qualquer stored procedure no banco
 * @param {string} procedure - Nome da procedure (ex: "sp_catalogo_acoes")
 * @param {object} params - Parâmetros da procedure
 * @returns {Promise<object>} - resultado da resposta
 */
const spApi = {
    /**
     * Modelo Antigo (legacy) - procedure + params
     * Mantido para compatibilidade
     */
    async call(procedure, params = {}) {
        const response = await fetch(API_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                procedure,
                params
            })
        });

        const data = await response.json();

        if (!data.sucesso) {
            throw new Error(data.mensagem || 'ERRO_SP');
        }

        return data.resultado;
    },

    /**
     * Modelo Novo (canônico) - metodo + rota + id_sessao + payload
     * Usado pelo AuthProvider
     */
    async callRoute({ metodo, rota, id_sessao, payload = {} }) {
        const response = await fetch(API_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                metodo,
                rota,
                id_sessao,
                payload
            })
        });

        const data = await response.json();

        if (!data.sucesso) {
            throw new Error(data.mensagem || 'ERRO_ROUTE');
        }

        return data.resultado;
    },
    
    /**
     * Alias para compatibilidade com código legado
     * Traduz formato antigo { modulo, acao, payload } para sp_master_routes
     */
    async executarOrquestradora(params) {
        const { id_sessao, modulo, acao, payload } = params;
        
        // Converte formato antigo para rota do sp_master_routes
        const rota = `${modulo}.${acao}`.toUpperCase();
        
        // Mapeia ação para método HTTP
        let metodo = 'POST';
        if (acao === 'request' || acao === 'REQUEST') metodo = 'REQUEST';
        else if (acao === 'get' || acao === 'GET' || acao === 'listar') metodo = 'GET';
        else if (acao === 'SALVAR' || acao.includes('SALVAR')) metodo = 'SET';
        
        const response = await fetch(API_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                metodo,
                rota,
                id_sessao,
                payload: payload || {}
            })
        });

        const data = await response.json();

        if (!data.sucesso) {
            throw new Error(data.mensagem || 'ERRO_ORQUESTRADOR');
        }

        return data.resultado;
    }
};

// Exporta a função para compatibilidade com código legado
export const executarOrquestradora = spApi.executarOrquestradora.bind(spApi);
export const spCall = spApi.callRoute.bind(spApi);
export default spApi;
