import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type { SessionId } from '../session/contracts/SessionContracts'
import type {
  PermissionCode,
  RoleData,
  AuthorizationRuntimeState,
  AuthorizationRuntimeMethods
} from './contracts/AuthorizationContracts'

/**
 * Runtime de Authorization do Kernel Enterprise (MD-KERNEL-005).
 *
 * @fileoverview Implementação canônica do AuthorizationRuntime.
 */
export class AuthorizationRuntime implements AuthorizationRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async evaluate(idSessao: SessionId): Promise<PermissionCode[]> {
    const response = await this.dispatcher.send({
      modulo: 'IAM',
      acao: 'AUTH.EVALUATE',
      payload: {},
      idSessao: Number(idSessao)
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_AVALIAR_PERMISSOES')
    }

    this.events?.track({ modulo: 'KERNEL', acao: 'AUTH.EVALUATED', payload: { id_sessao: idSessao } })
    return response.resultado as PermissionCode[]
  }

  async assert(idSessao: SessionId, permission: PermissionCode): Promise<void> {
    const response = await this.dispatcher.send({
      modulo: 'IAM',
      acao: 'AUTH.ASSERT',
      payload: { permission },
      idSessao: Number(idSessao)
    })

    if (!response.sucesso) {
      this.events?.track({ modulo: 'KERNEL', acao: 'AUTH.DENIED', payload: { id_sessao: idSessao, permission } })
      throw new Error(response.mensagem ?? 'PERMISSAO_NEGADA')
    }

    this.events?.track({ modulo: 'KERNEL', acao: 'AUTH.ASSERTED', payload: { id_sessao: idSessao, permission } })
  }

  async loadRoles(idSessao: SessionId): Promise<RoleData[]> {
    const response = await this.dispatcher.send({
      modulo: 'IAM',
      acao: 'AUTH.LOAD_ROLES',
      payload: {},
      idSessao: Number(idSessao)
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_CARREGAR_ROLES')
    }

    this.events?.track({ modulo: 'KERNEL', acao: 'AUTH.ROLES_LOADED', payload: { id_sessao: idSessao } })
    return response.resultado as RoleData[]
  }

  hasPermission(state: AuthorizationRuntimeState, permission: PermissionCode): boolean {
    return state.permissions.some((p) => p.codigo === permission)
  }

  compose(session: unknown): AuthorizationRuntimeState {
    return {
      permissions: [],
      roles: [],
      loading: false,
      error: null,
      hasPermission: () => false,
      isAuthorized: () => false
    }
  }
}
