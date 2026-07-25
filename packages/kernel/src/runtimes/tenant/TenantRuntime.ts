import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type {
  TenantId,
  TenantData,
  TenantRuntimeState,
  TenantRuntimeMethods
} from './contracts/TenantContracts'

/**
 * Runtime de Tenant do Kernel Enterprise (MD-KERNEL-002).
 *
 * @fileoverview Implementação canônica do TenantRuntime.
 */
export class TenantRuntime implements TenantRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async loadTenant(idTenante: TenantId): Promise<TenantData> {
    const response = await this.dispatcher.send({
      modulo: 'PORTAL',
      acao: 'TENANT.LOAD',
      payload: { id_tenant: idTenante },
      idSessao: Number(idTenante)
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_CARREGAR_TENANT')
    }

    const tenant = response.resultado as TenantData
    this.events?.track({ modulo: 'KERNEL', acao: 'TENANT.LOADED', payload: { id_tenant: idTenante } })
    return tenant
  }

  async listTenants(): Promise<TenantData[]> {
    const response = await this.dispatcher.send({
      modulo: 'PORTAL',
      acao: 'TENANT.LIST',
      payload: {},
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_LISTAR_TENANTS')
    }

    return response.resultado as TenantData[]
  }

  compose(session: unknown): TenantRuntimeState {
    const state: TenantRuntimeState = { tenant: null, loading: false, error: null }

    if (session && typeof session === 'object' && 'idSessao' in session) {
      const s = session as { idUnidade?: string; idLocal?: string; idPerfil?: string }
      state.tenant = {
        id: s.idUnidade ?? 'default',
        nome: 'Tenant Default',
        ativo: true
      } as TenantData
    }

    return state
  }
}
