export function hasPermission(permission: string, grantedPermissions: string[] = []): boolean {
  return grantedPermissions.includes(permission)
}

export function filterByPermission<T extends { permission?: string }>(
  items: T[],
  grantedPermissions: string[] = []
): T[] {
  return items.filter((item) => !item.permission || grantedPermissions.includes(item.permission))
}
