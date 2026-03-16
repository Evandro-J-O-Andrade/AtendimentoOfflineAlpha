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
    const token = localStorage.getItem("token");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Interceptor para tratar erros globais
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expirado ou inválido
      localStorage.removeItem("token");
      localStorage.removeItem("sessao");
      window.location.href = "/login";
    }
    return Promise.reject(error);
  }
);

/**
 * GET request
 * @param {string} url 
 * @returns {Promise<any>}
 */
export const apiGet = (url) => api.get(url).then((res) => res.data);

/**
 * POST request
 * @param {string} url 
 * @param {any} data 
 * @returns {Promise<any>}
 */
export const apiPost = (url, data) => api.post(url, data).then((res) => res.data);

/**
 * PUT request
 * @param {string} url 
 * @param {any} data 
 * @returns {Promise<any>}
 */
export const apiPut = (url, data) => api.put(url, data).then((res) => res.data);

/**
 * DELETE request
 * @param {string} url 
 * @returns {Promise<any>}
 */
export const apiDelete = (url) => api.delete(url).then((res) => res.data);

export default api;
