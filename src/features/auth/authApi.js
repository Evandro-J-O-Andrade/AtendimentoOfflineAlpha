import { http } from '../../shared/api/http.js'

// Contrato sugerido (adapte no backend):
// POST /auth/login {login, senha} -> {token, user}
// GET /auth/me -> {user}

export async function loginRequest(login, senha) {
  const { data } = await http.post('/auth/login', { login, senha })
  return data
}

export async function meRequest() {
  const { data } = await http.get('/auth/me')
  return data
}
