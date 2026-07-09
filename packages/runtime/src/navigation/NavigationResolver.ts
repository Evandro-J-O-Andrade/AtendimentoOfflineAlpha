import type { NavigationContract } from '@atendimentooffline/contracts'

export function resolveNavigation(
  navigation: NavigationContract[],
  grantedPermissions: string[] = []
): NavigationContract[] {
  return navigation.map((group) => ({
    ...group,
    items: group.items.filter(
      (item) => !item.permission || grantedPermissions.includes(item.permission)
    )
  }))
}
