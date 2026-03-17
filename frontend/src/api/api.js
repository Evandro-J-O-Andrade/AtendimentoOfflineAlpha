/**
 * API Base - Axios configurado para comunicação com backend
 *HIS/PA - Sistema de Prontuário Ambulatorial
 */

import axios from "axios";

const api = axios.create({
  baseURL: "/api",
  headers: {
    "Content-Type": "application/json",
  },
});

// Interceptor para adicionar token JWT em todas as requisições
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token_his");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Interceptor para tratar erros globais (expiração/401)
api.interceptors.response.use(
  (response) => response,
  (error) => {
    const status = error?.response?.status;
    const code = error?.response?.data?.error || error?.response?.data?.erro;

    if (status === 401 || code === "TOKEN_EXPIRADO") {
      localStorage.removeItem("token_his");
      localStorage.removeItem("hispa_auth");
      sessionStorage.removeItem("pending_context");
      window.location.replace("/login");
      return Promise.reject(error);
    }

    return Promise.reject(error);
  }
);

/**
 * GET request
 * @param {string} url 
 * @returns {Promise<any>}
 */
export const apiGet = (url, config) => api.get(url, config).then((res) => res.data);

/**
 * POST request
 * @param {string} url 
 * @param {any} data 
 * @returns {Promise<any>}
 */
export const apiPost = (url, data, config) => api.post(url, data, config).then((res) => res.data);

/**
 * PUT request
 * @param {string} url 
 * @param {any} data 
 * @returns {Promise<any>}
 */
export const apiPut = (url, data, config) => api.put(url, data, config).then((res) => res.data);

/**
 * DELETE request
 * @param {string} url 
 * @returns {Promise<any>}
 */
export const apiDelete = (url, config) => api.delete(url, config).then((res) => res.data);

export default api;
