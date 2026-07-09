export interface NavigationItemContract {
  id: string
  label: string
  route: string
  permission?: string
}

export interface NavigationContract {
  id: string
  label: string
  items: NavigationItemContract[]
}
