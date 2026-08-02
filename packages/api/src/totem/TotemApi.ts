import type { ApiClient } from '../index'
import type { TotemOpcao, TotemPlantaoItem, TotemSenhaRequest, TotemSenhaResponse } from '@atendimentooffline/contracts'

export interface TotemApi {
  listarOpcoes(params: { id_unidade: number; id_local_operacional: number; id_sessao: number }): Promise<TotemOpcao[]>
  buscarPlantaoMedico(params: { id_unidade: number; data?: string; id_sessao: number }): Promise<TotemPlantaoItem[]>
  gerarSenha(payload: TotemSenhaRequest & { id_sessao: number }): Promise<TotemSenhaResponse>
}

export function createTotemApi(api: ApiClient): TotemApi {
  const sessionHeaders = (idSessao: number) => ({ 'x-session-id': String(idSessao) } as Record<string, string>)

  return {
    async listarOpcoes({ id_unidade, id_local_operacional, id_sessao }) {
      const response = await api.get<{ sucesso: boolean; data: TotemOpcao[] }>(`/totem/opcoes?id_unidade=${id_unidade}&id_local_operacional=${id_local_operacional}`, sessionHeaders(id_sessao))
      return response.data
    },
    async buscarPlantaoMedico({ id_unidade, data, id_sessao }) {
      const query = new URLSearchParams({ id_unidade: String(id_unidade) })
      if (data) query.set('data', data)
      const response = await api.get<{ sucesso: boolean; data: TotemPlantaoItem[] }>(`/totem/plantao-medico?${query.toString()}`, sessionHeaders(id_sessao))
      return response.data
    },
    async gerarSenha(payload) {
      const { id_sessao, ...body } = payload
      const response = await api.post<{ sucesso: boolean; data: TotemSenhaResponse }>('/totem/gerar-senha', body, sessionHeaders(id_sessao))
      return response.data
    }
  }
}
