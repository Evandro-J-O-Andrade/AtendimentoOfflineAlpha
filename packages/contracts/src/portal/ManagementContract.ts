export interface ManagementContainerContract {
  id: string
  name: string
  route: string
}

export interface ManagementContract {
  enabled: boolean
  containers: ManagementContainerContract[]
}
