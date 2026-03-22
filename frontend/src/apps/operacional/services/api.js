import axios from "axios";

const API_BASE = "/api";

// Token de acesso (Armazenado em memória)
let accessToken = null;

const api = axios.create({
  baseURL: API_BASE,
  headers: {
    "Content-Type": "application/json",
  },
});

// Interceptor para adicionar token em todas as requisições
api.interceptors.request.use(
  (config) => {
    if (accessToken) {
      config.headers.Authorization = `Bearer ${accessToken}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Função para chamar Stored Procedures via sp_master_dispatcher
export const callSP = async (rota, payload = {}) => {
  try {
    // Converte "auth.login" -> "AUTH.LOGIN"
    const rotaFormatada = rota.toUpperCase().replace(".", ".");
    
    const response = await api.post("/sp", {
      metodo: "POST",
      rota: rotaFormatada,
      id_sessao: null,
      payload
    });
    
    return response.data;
  } catch (error) {
    console.error(`Erro ao chamar SP ${rota}:`, error);
    throw error;
  }
};

// Função para definir o token
export const setAccessToken = (token) => {
  accessToken = token;
};

// Função para obter o token
export const getAccessToken = () => accessToken;

export default api;
