import type { ApiClient } from '@atendimentooffline/api'
import type { PortalRuntimeContract } from '@atendimentooffline/contracts'
import type { PortalRuntimeInput } from '../contracts/RuntimeContracts'
import type {
  ApplicationContract,
  WidgetContract,
  NavigationContract,
  BrandingContract
} from '@atendimentooffline/contracts'
import { resolveApplications } from '../application/ApplicationResolver'
import { renderWidgets } from '../widget/WidgetRenderer'
import { resolveNavigation } from '../navigation/NavigationResolver'

const DEFAULT_BRANDING: BrandingContract = { name: 'Enterprise Portal' }

export class PortalRuntimeEngine {
  constructor(private readonly api: ApiClient) {}

  compose(input: PortalRuntimeInput): PortalRuntimeContract {
    return {
      user: input.session.person ?? null,
      tenant: input.tenant,
      context: input.context,
      applications: resolveApplications(input.applications, input.permissions),
      navigation: resolveNavigation(input.navigation, input.permissions),
      widgets: renderWidgets(input.widgets, input.permissions),
      dashboard: input.dashboard ?? undefined,
      branding: input.tenant?.branding ?? DEFAULT_BRANDING,
      notifications: input.notifications ?? [],
      management: input.management ?? undefined,
      permissions: input.permissions
    }
  }
}
