import axios from 'axios'; // Importa direto o axios

// Define a instância da API aqui dentro mesmo para testar
const api = axios.create({
    baseURL: 'http://localhost:3001' 
});

// Gera UUID nativo do browser
const gerarUuid = () => {
    return crypto.randomUUID();
};

export const useDispatcher = () => {
    const callDispatcher = async (dominio, acao, id_referencia, payload = {}) => {
        const id_sessao = localStorage.getItem('id_sessao'); 
        const uuid_transacao = gerarUuid(); 

        try {
            const response = await api.post('/api/dispatcher', {
                id_sessao,
                uuid_transacao,
                dominio,
                acao,
                id_referencia,
                payload
            });
            return response.data;
        } catch (error) {
            throw error.response?.data?.message || "Erro na transação";
        }
    };

    return { callDispatcher };
};

export default useDispatcher;
