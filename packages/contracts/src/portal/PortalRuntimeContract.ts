import type { PersonContract } from '../identity/PersonContract'
import type { TenantContract } from '../tenant/TenantContract'
import type { ContextContract } from '../context/ContextContract'
import type { ApplicationContract } from '../application/ApplicationContract'
import type { NavigationContract } from '../navigation/NavigationContract'
import type { WidgetContract } from '../widget/WidgetContract'
import type { DashboardContract } from '../dashboard/DashboardContract'
import type { BrandingContract } from '../branding/BrandingContract'
import type { NotificationContract } from '../notification/NotificationContract'
import type { ManagementContract } from './ManagementContract'

export interface PortalRuntimeContract {
  user: PersonContract | null
  tenant: TenantContract | null
  context: ContextContract | null
  applications: ApplicationContract[]
  navigation: NavigationContract[]
  widgets: WidgetContract[]
  dashboard?: DashboardContract
  branding: BrandingContract
  notifications?: NotificationContract[]
  management?: ManagementContract
  permissions: string[]
}
