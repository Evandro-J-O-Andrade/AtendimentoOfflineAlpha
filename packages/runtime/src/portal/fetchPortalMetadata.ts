import type { ApiClient } from '@atendimentooffline/api'
import type { PortalRuntimeInput } from '../contracts/RuntimeContracts'

export interface PortalMetadata {
  applications: PortalRuntimeInput['applications']
  widgets: PortalRuntimeInput['widgets']
  navigation: PortalRuntimeInput['navigation']
}

export async function fetchPortalMetadata(api: ApiClient): Promise<PortalMetadata> {
  const [applications, widgets, navigation] = await Promise.all([
    api.get<PortalRuntimeInput['applications']>('/portal/applications'),
    api.get<PortalRuntimeInput['widgets']>('/portal/widgets'),
    api.get<PortalRuntimeInput['navigation']>('/portal/navigation')
  ])
  return { applications, widgets, navigation }
}
