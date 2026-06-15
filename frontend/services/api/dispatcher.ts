import axios from 'axios';

const apiClient = axios.create({
    baseURL: '/api',
    headers: { 'Content-Type': 'application/json' },
});

let accessToken: string | null = null;

apiClient.interceptors.request.use((config) => {
    if (accessToken) {
        config.headers.Authorization = `Bearer ${accessToken}`;
    }
    return config;
});

export const setAccessToken = (token: string | null) => {
    accessToken = token;
};

export const dispatcher = async (params: {
    dominio: string;
    acao: string;
    payload?: Record<string, unknown>;
    idSessao?: number;
}) => {
    const response = await apiClient.post('/sp', {
        metodo: params.acao,
        rota: `${params.dominio}.${params.acao}`,
        id_sessao: params.idSessao,
        payload: params.payload
    });
    return response.data;
};

export default apiClient;