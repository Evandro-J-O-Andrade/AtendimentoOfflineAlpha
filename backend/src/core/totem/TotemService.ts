import { randomUUID } from 'node:crypto'
import { dispatcherService } from '../dispatcher/DispatcherService'
import type { DispatcherResponse } from '../dispatcher/DispatcherService'

export interface TotemSenhaRequest {
  id_opcao: number
  id_unidade: number
  id_local_operacional: number
  id_paciente?: number | null
}

export interface TotemSenhaResponse {
  id_senha: number
  numero_senha: string
  tipo_atendimento: string
  prefixo: string
  uuid_transacao: string
  mensagem: string
}

export class TotemService {
  async listarOpcoes(idSessao: number, id_unidade: number, id_local_operacional: number): Promise<unknown> {
    const response = await dispatcherService.dispatch({
      capability: 'TOTEM.OPCOES_GET',
      payload: { id_unidade, id_local_operacional },
      context: { id_sessao: idSessao, id_unidade },
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_LISTAR_OPCOES')
    }

    const raw = (response.resultado as any)?.resultado ?? response.resultado
    return raw
  }

  async buscarPlantaoMedico(idSessao: number, id_unidade: number, data?: string): Promise<unknown> {
    const response = await dispatcherService.dispatch({
      capability: 'TOTEM.PLANTAO_MEDICO_GET',
      payload: { id_unidade, data: data ?? null },
      context: { id_sessao: idSessao, id_unidade },
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_BUSCAR_PLANTAO')
    }

    const raw = (response.resultado as any)?.resultado ?? response.resultado
    return raw
  }

  async gerarSenha(idSessao: number, payload: TotemSenhaRequest): Promise<TotemSenhaResponse> {
    const uuid_transacao = randomUUID()

    const response = await dispatcherService.dispatch({
      capability: 'TOTEM.GERAR_SENHA',
      payload: {
        id_opcao: payload.id_opcao,
        id_unidade: payload.id_unidade,
        id_local_operacional: payload.id_local_operacional,
        id_paciente: payload.id_paciente ?? null,
      },
      context: { id_sessao: idSessao, id_unidade: payload.id_unidade },
      uuid_transacao,
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_GERAR_SENHA')
    }

    const raw = (response.resultado as any)?.resultado ?? response.resultado

    return {
      id_senha: Number(raw?.id_senha ?? 0),
      numero_senha: String(raw?.numero_senha ?? ''),
      tipo_atendimento: String(raw?.tipo_atendimento ?? ''),
      prefixo: String(raw?.prefixo ?? ''),
      uuid_transacao: String(raw?.uuid_transacao ?? uuid_transacao),
      mensagem: String(raw?.mensagem ?? 'Senha gerada com sucesso'),
    }
  }
}

export const totemService = new TotemService()