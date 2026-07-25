import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type {
  NavigationItem,
  NavigationGroup,
  NavigationState,
  NavigationRuntimeMethods
} from './contracts/NavigationContracts'

/**
 * Runtime de Navigation do Kernel Enterprise (MD-KERNEL-010).
 *
 * @fileoverview Implementação canônica do NavigationRuntime.
 */
export class NavigationRuntime implements NavigationRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async load(idSessao: number): Promise<NavigationGroup[]> {
    const response = await this.dispatcher.send({
      modulo: 'PORTAL',
      acao: 'NAVIGATION.LOAD',
      payload: {},
      idSessao
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_CARREGAR_NAVEGACAO')
    }

    const groups = response.resultado as NavigationGroup[]
    this.events?.track({ modulo: 'KERNEL', acao: 'NAVIGATION_LOADED', payload: { id_sessao: idSessao } })
    return groups
  }

  async findByRoute(route: string): Promise<NavigationItem | undefined> {
    const response = await this.dispatcher.send({
      modulo: 'PORTAL',
      acao: 'NAVIGATION.FIND_BY_ROUTE',
      payload: { route },
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      return undefined
    }

    return response.resultado as NavigationItem
  }

  async filterByPermission(permissions: string[]): Promise<NavigationGroup[]> {
    const response = await this.dispatcher.send({
      modulo: 'PORTAL',
      acao: 'NAVIGATION.FILTER_BY_PERMISSION',
      payload: { permissions },
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      return []
    }

    return response.resultado as NavigationGroup[]
  }

  compose(session: unknown, _permissions: string[]): NavigationState {
    return {
      groups: [],
      loading: false,
      error: null,
      currentRoute: undefined,
      currentItem: undefined
    }
  }
}
