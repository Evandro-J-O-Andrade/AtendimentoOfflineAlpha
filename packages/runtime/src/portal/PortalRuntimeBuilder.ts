import type { ApiClient } from '@atendimentooffline/api'
import type { PortalRuntimeContract } from '@atendimentooffline/contracts'
import type { PortalRuntimeInput } from '../contracts/RuntimeContracts'
import { PortalRuntimeEngine } from './PortalRuntimeEngine'

export class PortalRuntimeBuilder {
  private input: Partial<PortalRuntimeInput> = {}

  constructor(private readonly api: ApiClient) {}

  withSession(session: PortalRuntimeInput['session']) {
    this.input.session = session
    return this
  }
  withTenant(tenant: PortalRuntimeInput['tenant']) {
    this.input.tenant = tenant
    return this
  }
  withContext(context: PortalRuntimeInput['context']) {
    this.input.context = context
    return this
  }
  withApplications(applications: PortalRuntimeInput['applications']) {
    this.input.applications = applications
    return this
  }
  withWidgets(widgets: PortalRuntimeInput['widgets']) {
    this.input.widgets = widgets
    return this
  }
  withNavigation(navigation: PortalRuntimeInput['navigation']) {
    this.input.navigation = navigation
    return this
  }
  withDashboard(dashboard: PortalRuntimeInput['dashboard']) {
    this.input.dashboard = dashboard
    return this
  }
  withNotifications(notifications: NonNullable<PortalRuntimeInput['notifications']>) {
    this.input.notifications = notifications
    return this
  }
  withManagement(management: PortalRuntimeInput['management']) {
    this.input.management = management
    return this
  }
  withPermissions(permissions: string[]) {
    this.input.permissions = permissions
    return this
  }

  build(): PortalRuntimeContract {
    const engine = new PortalRuntimeEngine(this.api)
    return engine.compose(this.input as PortalRuntimeInput)
  }
}
