import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type { SessionId } from '../session/contracts/SessionContracts'
import type {
  UnidadeData,
  PerfilData,
  LocalData,
  ContextSelection,
  ContextRuntimeState,
  ContextRuntimeMethods,
  UnidadeId,
  PerfilId,
  LocalId
} from './contracts/ContextContracts'

/**
 * Runtime de Context do Kernel Enterprise (MD-KERNEL-004).
 *
 * @fileoverview Implementação canônica do ContextRuntime.
 */
export class ContextRuntime implements ContextRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async loadUnidades(idSessao: SessionId): Promise<UnidadeData[]> {
    const response = await this.dispatcher.send({
      modulo: 'IAM',
      acao: 'CONTEXT.LOAD_UNIDADES',
      payload: {},
      idSessao: Number(idSessao)
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_CARREGAR_UNIDADES')
    }

    this.events?.track({ modulo: 'KERNEL', acao: 'CONTEXT.UNIDADES_LOADED', payload: { id_sessao: idSessao } })
    return response.resultado as UnidadeData[]
  }

  async loadPerfis(idSessao: SessionId, idUnidade: UnidadeId): Promise<PerfilData[]> {
    const response = await this.dispatcher.send({
      modulo: 'IAM',
      acao: 'CONTEXT.LOAD_PERFIS',
      payload: { id_unidade: idUnidade },
      idSessao: Number(idSessao)
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_CARREGAR_PERFIS')
    }

    this.events?.track({ modulo: 'KERNEL', acao: 'CONTEXT.PERFIS_LOADED', payload: { id_sessao: idSessao, id_unidade: idUnidade } })
    return response.resultado as PerfilData[]
  }

  async loadLocais(idSessao: SessionId, idUnidade: UnidadeId): Promise<LocalData[]> {
    const response = await this.dispatcher.send({
      modulo: 'IAM',
      acao: 'CONTEXT.LOAD_LOCAIS',
      payload: { id_unidade: idUnidade },
      idSessao: Number(idSessao)
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_CARREGAR_LOCAIS')
    }

    this.events?.track({ modulo: 'KERNEL', acao: 'CONTEXT.LOCAIS_LOADED', payload: { id_sessao: idSessao, id_unidade: idUnidade } })
    return response.resultado as LocalData[]
  }

  async selectContext(
    idSessao: SessionId,
    idUnidade: UnidadeId,
    idPerfil: PerfilId,
    idLocal: LocalId
  ): Promise<ContextSelection> {
    const response = await this.dispatcher.send({
      modulo: 'IAM',
      acao: 'CONTEXT.SELECT',
      payload: { id_unidade: idUnidade, id_perfil: idPerfil, id_local: idLocal },
      idSessao: Number(idSessao)
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_SELECIONAR_CONTEXTO')
    }

    const selection = response.resultado as ContextSelection
    this.events?.track({ modulo: 'KERNEL', acao: 'CONTEXT.SELECTED', payload: { id_sessao: idSessao, selection } })
    return selection
  }

  compose(session: unknown): ContextRuntimeState {
    return {
      unidades: [],
      perfis: [],
      salas: [],
      selected: null,
      loading: false,
      error: null
    }
  }
}
