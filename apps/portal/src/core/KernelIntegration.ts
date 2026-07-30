import { ApiDispatcherClientAdapter, IdentityRuntime, TenantRuntime, SessionRuntime, ContextRuntime, AuthorizationRuntime, NavigationRuntime } from '@atendimentooffline/kernel'
import type { PortalRuntimeContract } from '@atendimentooffline/contracts'
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

  return {
    async loadRuntime(idSessao: number) {
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

      const runtime = engine.compose({
        session: sessionData ?? { authenticated: false },
        tenant: tenantData,
        context: context,
        applications: applicationsData,
        widgets: [],
        navigation: navigationData,
        dashboard: dashboardData,
        notifications: [],
        management: { enabled: false, containers: [] },
        permissions: []
      })

      state.runtime = runtime
    }
  }
}
