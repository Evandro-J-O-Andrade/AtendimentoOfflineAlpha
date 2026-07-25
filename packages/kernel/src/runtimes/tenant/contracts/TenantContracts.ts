/**
 * @fileoverview Contratos canônicos do TenantRuntime.
 * @module kernel.runtimes.tenant.contracts
 * @description Define tipos e interfaces do domínio Tenant (MD-KERNEL-002).
 */

export type TenantId = string | number

export interface TenantData {
  id: TenantId
  nome: string
  documento?: string
  ativo: boolean
}

export interface TenantRuntimeState {
  tenant?: TenantData | null
  loading: boolean
  error?: string | null
}

export interface TenantRuntimeMethods {
  loadTenant(idTenante: TenantId): Promise<TenantData>
  listTenants(): Promise<TenantData[]>
  compose(session: unknown): TenantRuntimeState
}
