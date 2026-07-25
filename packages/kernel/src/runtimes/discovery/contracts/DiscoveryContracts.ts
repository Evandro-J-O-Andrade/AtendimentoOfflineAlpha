/**
 * @fileoverview Contratos canônicos do DiscoveryRuntime.
 * @module kernel.runtimes.discovery.contracts
 * @description Define tipos e interfaces do domínio Discovery (MD-KERNEL-006).
 */

export interface ServiceEndpoint {
  service: string
  url: string
  method: string
  authRequired: boolean
  version: string
}

export interface CapabilityManifest {
  id: string
  nome: string
  versao: string
  endpoints: ServiceEndpoint[]
  dependencies: string[]
}

export type DiscoveryEventType =
  | 'DISCOVERY_SYNC_COMPLETED'
  | 'DISCOVERY_ENDPOINT_REGISTERED'
  | 'DISCOVERY_CAPABILITY_DISCOVERED'
  | 'DISCOVERY_ERROR'

export interface DiscoveryRuntimeState {
  services: ServiceEndpoint[]
  capabilities: CapabilityManifest[]
  loading: boolean
  error?: string | null
  lastSync: Date | null
}

export interface DiscoveryRuntimeMethods {
  discover(options?: { ttl?: number; forceRefresh?: boolean }): Promise<ServiceEndpoint[]>
  register(endpoint: ServiceEndpoint): Promise<void>
  listCapabilities(options?: { ttl?: number; forceRefresh?: boolean }): Promise<CapabilityManifest[]>
  getEndpoint(service: string, method: string): ServiceEndpoint | undefined
  compose(): DiscoveryRuntimeState
}
