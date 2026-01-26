import axios from 'axios'

const baseURL = import.meta.env.VITE_API_BASE || '/api'

export const http = axios.create({
  baseURL,
  withCredentials: false
})

export function setAuthToken(token) {
  if (token) {
    http.defaults.headers.common.Authorization = `Bearer ${token}`
  } else {
    delete http.defaults.headers.common.Authorization
  }
}

export function apiErrorMessage(err) {
  const data = err?.response?.data
  if (typeof data === 'string') return data
  if (data?.mensagem) return data.mensagem
  if (data?.message) return data.message
  return err?.message || 'Erro inesperado'
}
