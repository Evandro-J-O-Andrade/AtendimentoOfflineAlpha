/**
 * @fileoverview Contratos canônicos do RegistryRuntime.
 * @module kernel.runtimes.registry.contracts
 * @description Define tipos e interfaces do domínio Registry (MD-KERNEL-007).
 */

export interface RegistryEntry {
  id: string
  nome: string
  tipo: string
  modulo: string
  acao: string
  version: string
  ativo: boolean
}

export type RegistryEventType =
  | 'REGISTRY_ENTRY_REGISTERED'
  | 'REGISTRY_ENTRY_UNREGISTERED'
  | 'REGISTRY_SYNC_COMPLETED'
  | 'REGISTRY_ERROR'

export interface RegistryRuntimeState {
  entries: RegistryEntry[]
  loading: boolean
  error?: string | null
  getEntry: (id: string) => RegistryEntry | undefined
  findEntries: (modulo: string, acao?: string) => RegistryEntry[]
}

export interface RegistryRuntimeMethods {
  register(entry: RegistryEntry): Promise<void>
  unregister(id: string): Promise<void>
  findByModulo(modulo: string): Promise<RegistryEntry[]>
  findByAcao(modulo: string, acao: string): Promise<RegistryEntry | undefined>
  list(): Promise<RegistryEntry[]>
  compose(session: unknown): RegistryRuntimeState
}
