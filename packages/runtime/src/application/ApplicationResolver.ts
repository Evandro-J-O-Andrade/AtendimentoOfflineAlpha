import type { ApplicationContract } from '@atendimentooffline/contracts'

export function resolveApplications(
  applications: ApplicationContract[],
  grantedPermissions: string[] = []
): ApplicationContract[] {
  return applications
    .filter((a) => a.enabled)
    .filter((a) => !a.permission || grantedPermissions.includes(a.permission))
}
