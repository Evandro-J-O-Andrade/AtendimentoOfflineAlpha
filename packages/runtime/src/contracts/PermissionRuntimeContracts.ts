import type { AuthSessionContract, TenantContract, ContextContract } from '@atendimentooffline/contracts'

export interface PermissionRuntimeInput {
  session: AuthSessionContract
  tenant: TenantContract | null
  context: ContextContract | null
  grantedPermissions: string[]
}

export interface PermissionResolutionResult {
  permissions: string[]
}
