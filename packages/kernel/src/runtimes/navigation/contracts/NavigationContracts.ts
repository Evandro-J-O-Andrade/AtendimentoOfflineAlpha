/**
 * @fileoverview Contratos canônicos do NavigationRuntime.
 * @module kernel.runtimes.navigation.contracts
 * @description Define tipos e interfaces do domínio Navigation (MD-KERNEL-010).
 */

export interface NavigationItem {
  id: string
  label: string
  route: string
  icon?: string
  permission?: string
}

export interface NavigationGroup {
  id: string
  label: string
  items: NavigationItem[]
}

export interface NavigationState {
  groups: NavigationGroup[]
  loading: boolean
  error?: string | null
  currentRoute?: string
  currentItem?: NavigationItem
}

export interface NavigationRuntimeMethods {
  load(idSessao: number): Promise<NavigationGroup[]>
  findByRoute(route: string): Promise<NavigationItem | undefined>
  filterByPermission(permissions: string[]): Promise<NavigationGroup[]>
  compose(session: unknown, permissions: string[]): NavigationState
}
