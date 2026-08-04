import { ApiDispatcherClientAdapter, IdentityRuntime, TenantRuntime, SessionRuntime, ContextRuntime, AuthorizationRuntime, NavigationRuntime } from '@atendimentooffline/kernel'
import type { PortalRuntimeContract, TenantContract, ContextContract } from '@atendimentooffline/contracts'
import { PortalRuntimeEngine } from '@atendimentooffline/runtime'
import { portalConfig } from '../app/config'

export interface PortalRuntimeBridgeState {
  runtime: PortalRuntimeContract | null
  loading: boolean
  error: string | null
}

export interface PortalRuntimeBridge {
  loadRuntime(idSessao: number): Promise<void>
  state: PortalRuntimeBridgeState
}

export function createPortalRuntimeBridge(): PortalRuntimeBridge {
  const baseUrl = portalConfig.apiUrl
  const dispatcher = new ApiDispatcherClientAdapter(baseUrl)

  const identity = new IdentityRuntime(dispatcher)
  const tenant = new TenantRuntime(dispatcher)
  const session = new SessionRuntime(dispatcher)
  const context = new ContextRuntime(dispatcher)
  const authorization = new AuthorizationRuntime(dispatcher)
  const navigation = new NavigationRuntime(dispatcher)

  const engine = new PortalRuntimeEngine(dispatcher as any)

  const state: PortalRuntimeBridgeState = {
    runtime: null,
    loading: false,
    error: null
  }

  return {
    state,

    async loadRuntime(idSessao: number) {
      state.loading = true
      state.error = null

      try {
        const [sessionData, tenantData, navigationData, applicationsData, brandingData, dashboardData] = await Promise.all([
          new Promise<{ authenticated: boolean; id_sessao_usuario?: number; id_usuario?: number; id_entidade?: number; id_unidade?: number; id_local?: number; id_perfil?: number; token_jwt?: string; refresh_token?: string; expira_em?: string } | null>((resolve) => {
            dispatcher.send({ modulo: 'AUTH', acao: 'SESSION.VALIDATE', payload: {}, idSessao: idSessao })
              .then((res) => resolve(res.sucesso ? res.resultado as any : null))
              .catch(() => resolve(null))
          }),
          tenant.listTenants().catch(() => null),
          navigation.load(idSessao).catch(() => []),
          new Promise<any[]>((resolve) => {
            dispatcher.send({ modulo: 'PORTAL', acao: 'APPLICATIONS.LIST', payload: {}, idSessao: idSessao })
              .then((res) => resolve(res.sucesso ? res.resultado as any[] : []))
              .catch(() => resolve([]))
          }),
          new Promise<any>((resolve) => {
            dispatcher.send({ modulo: 'PORTAL', acao: 'BRANDING.LOAD', payload: {}, idSessao: idSessao })
              .then((res) => resolve(res.sucesso ? res.resultado : null))
              .catch(() => resolve(null))
          }),
          new Promise<any>((resolve) => {
            dispatcher.send({ modulo: 'PORTAL', acao: 'DASHBOARD.LOAD', payload: {}, idSessao: idSessao })
              .then((res) => resolve(res.sucesso ? res.resultado : null))
              .catch(() => resolve(null))
          })
        ])

        const tenantList = Array.isArray(tenantData) ? tenantData : []
        const firstTenant = tenantList[0]
        const tenantContract: TenantContract | null = firstTenant
          ? {
              id: String(firstTenant.id),
              name: firstTenant.nome,
              slug: String(firstTenant.id)
            }
          : null

        const runtimeContext = (sessionData as any)?.contexto ?? null

        const contextContract: ContextContract | null = runtimeContext
          ? {
              id: String(runtimeContext.id),
              tenantId: String(runtimeContext.tenantId ?? runtimeContext.idTenant ?? tenantContract?.id ?? ''),
              name: runtimeContext.name ?? runtimeContext.nome ?? '',
              kind: runtimeContext.kind ?? runtimeContext.tipo ?? 'UNIT'
            }
          : null

        const runtime = engine.compose({
          session: sessionData ?? { authenticated: false },
          tenant: tenantContract,
          context: contextContract,
          applications: applicationsData,
          widgets: [],
          navigation: navigationData,
          dashboard: dashboardData,
          notifications: [],
          management: { enabled: false, containers: [] },
          permissions: []
        })

        state.runtime = runtime
      } catch (error) {
        state.error = error instanceof Error ? error.message : 'Erro Kernel'
      } finally {
        state.loading = false
      }
    }
  }
}
