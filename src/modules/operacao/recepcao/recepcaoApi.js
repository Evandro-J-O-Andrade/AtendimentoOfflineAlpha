import { http } from '../../../shared/api/http.js'

// Contrato sugerido (backend pode mapear para as SPs):
// GET  /recepcao/fila -> {itens: [...]} | [...]
// POST /recepcao/chamar {id_senha, guiche} -> {ok:true}
// POST /recepcao/samu  {tipo:'EMERGENCIA'|...} -> {id_senha, numero, prefixo}
// POST /recepcao/complementar {id_senha,...dados} -> {id_ffa}
// POST /recepcao/encaminhar {id_senha, destino, id_local_destino} -> {ok:true}

export async function obterFilaRecepcao() {
  const { data } = await http.get('/recepcao/fila')
  return data.itens || data
}

export async function chamarSenha({ id_senha, guiche }) {
  const { data } = await http.post('/recepcao/chamar', { id_senha, guiche })
  return data
}

export async function gerarSenhaSamu() {
  const { data } = await http.post('/recepcao/samu', {})
  return data
}

export async function complementarAtendimento(payload) {
  const { data } = await http.post('/recepcao/complementar', payload)
  return data
}

export async function encaminharAtendimento(payload) {
  const { data } = await http.post('/recepcao/encaminhar', payload)
  return data
}
