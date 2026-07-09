import type { WidgetContract } from '../widget/WidgetContract'

export interface DashboardContract {
  id: string
  title: string
  layout: string
  widgets: WidgetContract[]
}
