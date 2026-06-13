import axios from "axios";

const API_BASE = "/api";

let accessToken: string | null = null;

const apiClient = axios.create({
  baseURL: API_BASE,
  headers: {
    "Content-Type": "application/json",
  },
});

apiClient.interceptors.request.use(
  (config) => {
    if (accessToken) {
      config.headers.Authorization = `Bearer ${accessToken}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

export const callSP = async (rota: string, payload = {}) => {
  try {
    const rotaFormatada = rota.toUpperCase().replace(".", ".");
    
    const response = await apiClient.post("/sp", {
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

export const setAccessToken = (token: string | null) => {
  accessToken = token;
};

export const getAccessToken = () => accessToken;

export const api = apiClient;

export default apiClient;