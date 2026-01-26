import { http } from '../../shared/api/http.js'

// Contrato sugerido:
// GET /contextos -> {contextos: [...]} | [...]
// POST /sessao/abrir -> {sessao_id, contexto}

export async function listarContextos() {
  const { data } = await http.get('/contextos')
  return data.contextos || data
}

export async function abrirSessao(contexto) {
  const { data } = await http.post('/sessao/abrir', contexto)
  return data
}

export async function encerrarSessao() {
  const { data } = await http.post('/sessao/encerrar')
  return data
}
