/**
 * @fileoverview Contratos canônicos do AuthorizationRuntime.
 * @module kernel.runtimes.authorization.contracts
 * @description Define tipos e interfaces do domínio Authorization (MD-KERNEL-005).
 */

import type { SessionId } from '../../session/contracts/SessionContracts'
import type { PerfilId } from '../../context/contracts/ContextContracts'

export type PermissionCode = string

export type { SessionId } from '../../session/contracts/SessionContracts'
export type { PerfilId } from '../../context/contracts/ContextContracts'

export interface PermissionData {
  codigo: PermissionCode
  descricao: string
  modulo: string
}

export interface RoleData {
  id_perfil: PerfilId
  nome_perfil: string
  permissions: PermissionData[]
}

export interface AuthorizationRuntimeState {
  permissions: PermissionData[]
  roles: RoleData[]
  loading: boolean
  error?: string | null
  hasPermission: (permission: PermissionCode) => boolean
  isAuthorized: (permissionCodes: PermissionCode[]) => boolean
}

export interface AuthorizationRuntimeMethods {
  evaluate(idSessao: SessionId): Promise<PermissionCode[]>
  assert(idSessao: SessionId, permission: PermissionCode): Promise<void>
  loadRoles(idSessao: SessionId): Promise<RoleData[]>
  hasPermission(state: AuthorizationRuntimeState, permission: PermissionCode): boolean
  compose(session: unknown): AuthorizationRuntimeState
}
