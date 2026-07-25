/**
 * @fileoverview Contratos canônicos do CapabilityRuntime.
 * @module kernel.runtimes.capability.contracts
 * @description Define tipos e interfaces do domínio Capability (MD-KERNEL-008).
 */

export type CapabilityId = string

export interface CapabilityData {
  id: CapabilityId
  nome: string
  descricao: string
  modulo: string
  dependencies: CapabilityId[]
  enabled: boolean
}

export type CapabilityEventType =
  | 'CAPABILITY_ENABLED'
  | 'CAPABILITY_DISABLED'
  | 'CAPABILITY_DEPENDENCY_CHECKED'
  | 'CAPABILITY_SYNC_COMPLETED'
  | 'CAPABILITY_ERROR'

export interface CapabilityRuntimeState {
  capabilities: CapabilityData[]
  loading: boolean
  error: string | null
  isEnabled: (id: CapabilityId) => boolean
  enable: (id: CapabilityId) => Promise<void>
  disable: (id: CapabilityId) => Promise<void>
}

export interface CapabilityRuntimeMethods {
  list(): Promise<CapabilityData[]>
  enable(id: CapabilityId): Promise<void>
  disable(id: CapabilityId): Promise<void>
  checkDependencies(id: CapabilityId): Promise<boolean>
  compose(session: unknown): CapabilityRuntimeState
}
