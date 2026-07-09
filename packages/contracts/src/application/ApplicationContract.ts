export interface ApplicationContract {
  id: string
  code: string
  name: string
  icon?: string
  route: string
  category?: string
  enabled: boolean
  licensed?: boolean
  permission?: string
}
