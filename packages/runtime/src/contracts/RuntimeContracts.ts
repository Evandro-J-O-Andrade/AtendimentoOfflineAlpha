import type {
  AuthSessionContract,
  TenantContract,
  ContextContract,
  ApplicationContract,
  WidgetContract,
  NavigationContract,
  DashboardContract,
  NotificationContract,
  ManagementContract
} from '@atendimentooffline/contracts'

export interface PortalRuntimeInput {
  session: AuthSessionContract
  tenant: TenantContract | null
  context: ContextContract | null
  applications: ApplicationContract[]
  widgets: WidgetContract[]
  navigation: NavigationContract[]
  dashboard?: DashboardContract | null
  notifications?: NotificationContract[]
  management?: ManagementContract | null
  permissions: string[]
}

export type ContextResolutionStatus = 'ACTIVE' | 'CONTEXT_SELECTION_REQUIRED'

export interface ContextResolutionResult {
  status: ContextResolutionStatus
  context?: ContextContract | null
  available: ContextContract[]
}

export interface ResolvedApplications {
  applications: ApplicationContract[]
}

export interface ResolvedWidgets {
  widgets: WidgetContract[]
}

export interface ResolvedNavigation {
  navigation: NavigationContract[]
}
