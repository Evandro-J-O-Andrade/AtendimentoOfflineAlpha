import type { ApiClient } from '../index'
import type { PortalRuntimeContract } from '@atendimentooffline/contracts'

export interface PortalApi {
  runtime(idSessao: number): Promise<PortalRuntimeContract>
  permissions(idSessao: number): Promise<string[]>
  navigation(idSessao: number): Promise<PortalRuntimeContract['navigation']>
  applications(idSessao: number): Promise<PortalRuntimeContract['applications']>
  branding(): Promise<PortalRuntimeContract['branding']>
  dashboard(idSessao: number): Promise<PortalRuntimeContract['dashboard']>
  widgets(idSessao: number): Promise<PortalRuntimeContract['widgets']>
  notifications(idSessao: number): Promise<PortalRuntimeContract['notifications']>
}

export function createPortalApi(api: ApiClient): PortalApi {
  return {
    async runtime(idSessao) {
      return api.get<PortalRuntimeContract>(`/portal/runtime/${idSessao}`)
    },
    async permissions(idSessao) {
      const response = await api.get<{ permissions: string[] }>(`/portal/permissions/${idSessao}`)
      return response.permissions
    },
    async navigation(idSessao) {
      return api.get<PortalRuntimeContract['navigation']>(`/portal/navigation/${idSessao}`)
    },
    async applications(idSessao) {
      const response = await api.get<{ applications: PortalRuntimeContract['applications'] }>(`/portal/applications/${idSessao}`)
      return response.applications
    },
    async branding() {
      return api.get<PortalRuntimeContract['branding']>('/portal/branding')
    },
    async dashboard(idSessao) {
      return api.get<PortalRuntimeContract['dashboard']>(`/portal/dashboard/${idSessao}`)
    },
    async widgets(idSessao) {
      const response = await api.get<{ widgets: PortalRuntimeContract['widgets'] }>(`/portal/widgets/${idSessao}`)
      return response.widgets
    },
    async notifications(idSessao) {
      const response = await api.get<{ notifications: PortalRuntimeContract['notifications'] }>(`/portal/notifications/${idSessao}`)
      return response.notifications
    }
  }
}
