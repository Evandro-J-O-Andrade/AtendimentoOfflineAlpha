import axios from 'axios';

/**
 * NEW WAVE ENTERPRISE - Gateway Único de API
 * Enforça a Lei Canônica: Frontend -> API -> sp_master_dispatcher
 */

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || '/api',
  headers: { 'Content-Type': 'application/json' },
});

// Interceptor para injetar o Token de Identidade
api.interceptors.request.use((config) => {
  const token = sessionStorage.getItem('@Enterprise:token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

/**
 * Ponto único de execução para qualquer ação de negócio
 */
export const executeAction = async (
  rota: string,
  payload: any = {},
  contexto: any = {},
) => {
  try {
    const response = await api.post('/runtime/dispatch', {
      action: rota.toUpperCase(),
      context: contexto, // Injeta o ContextContext
      payload,
    });
    return response.data;
  } catch (error) {
    console.error(`Action Execution Error [${rota}]:`, error);
    throw error;
  }
};

export default api;
