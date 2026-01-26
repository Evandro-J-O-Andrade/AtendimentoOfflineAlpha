import { http } from '../../../shared/api/http.js'

// Contrato sugerido (TOTEM):
// GET  /totem/plantao -> {medicos:[{nome,tipo}]}
// POST /totem/senha {tipo_atendimento} -> {id_senha, prefixo, numero}

export async function obterPlantaoTotem() {
  const { data } = await http.get('/totem/plantao')
  return data.medicos || data
}

export async function gerarSenhaTotem(tipo_atendimento) {
  const { data } = await http.post('/totem/senha', { tipo_atendimento })
  return data
}
