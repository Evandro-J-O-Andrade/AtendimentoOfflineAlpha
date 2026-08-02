import { randomUUID } from 'node:crypto'
import { dispatcherService } from '../dispatcher/DispatcherService'
import { permissionService } from '../permissions/PermissionService'
import { eventService } from '../eventos/EventService'

export interface TotemOpcao {
  id_opcao: number
  codigo: string
  label: string
  lane: string
  tipo_atendimento: string
  prefixo: string
  ordem: number
  ativo: number
}

export interface TotemPlantaoItem {
  especialidade: string
  medico_nome: string
  crm: string
}

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
  async listarOpcoes(idSessao: number, id_unidade: number, id_local_operacional: number): Promise<TotemOpcao[]> {
    await permissionService.assert(idSessao, 'TOTEM_OPCOES_READ')

    const response = await dispatcherService.dispatch({
      modulo: 'totem',
      acao: 'opcoes_get',
      payload: { id_unidade, id_local_operacional },
      id_sessao: idSessao
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_LISTAR_OPCOES')
    }

    const raw = response.resultado as any
    const opcoes = raw?.opcoes ?? raw
    return Array.isArray(opcoes) ? opcoes : []
  }

  async buscarPlantaoMedico(idSessao: number, id_unidade: number, data?: string): Promise<TotemPlantaoItem[]> {
    await permissionService.assert(idSessao, 'TOTEM_PLANTAO_READ')

    const response = await dispatcherService.dispatch({
      modulo: 'totem',
      acao: 'plantao_medico_get',
      payload: { id_unidade, data: data ?? null },
      id_sessao: idSessao
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_BUSCAR_PLANTAO')
    }

    const raw = response.resultado as any
    const plantao = raw?.plantao ?? raw
    return Array.isArray(plantao) ? plantao : []
  }

  async gerarSenha(idSessao: number, payload: TotemSenhaRequest): Promise<TotemSenhaResponse> {
    await permissionService.assert(idSessao, 'TOTEM_SENHA_GERAR')

    const uuid_transacao = randomUUID()

    const response = await dispatcherService.dispatch({
      modulo: 'totem',
      acao: 'gerar_senha',
      payload: {
        id_opcao: payload.id_opcao,
        id_unidade: payload.id_unidade,
        id_local_operacional: payload.id_local_operacional,
        id_paciente: payload.id_paciente ?? null
      },
      id_sessao: idSessao,
      uuid_transacao
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_GERAR_SENHA')
    }

    const raw = response.resultado as any

    try {
      await eventService.registrar(
        idSessao,
        'totem',
        'SENHA_GERADA',
        { id_senha: raw.id_senha, numero_senha: raw.numero_senha, uuid_transacao },
        'TOTEM'
      )
    } catch (eventError) {
      console.warn('Falha ao registrar evento Totem', eventError)
    }

    return {
      id_senha: Number(raw.id_senha ?? 0),
      numero_senha: String(raw.numero_senha ?? ''),
      tipo_atendimento: String(raw.tipo_atendimento ?? ''),
      prefixo: String(raw.prefixo ?? ''),
      uuid_transacao: String(raw.uuid_transacao ?? uuid_transacao),
      mensagem: String(raw.mensagem ?? 'Senha gerada com sucesso')
    }
  }
}

export const totemService = new TotemService()
