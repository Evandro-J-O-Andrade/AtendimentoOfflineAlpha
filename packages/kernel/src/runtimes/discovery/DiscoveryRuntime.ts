import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type {
  ServiceEndpoint,
  CapabilityManifest,
  DiscoveryRuntimeState,
  DiscoveryRuntimeMethods
} from './contracts/DiscoveryContracts'

/**
 * Runtime de Discovery do Kernel Enterprise (MD-KERNEL-006).
 *
 * @fileoverview Implementação canônica do DiscoveryRuntime.
 */
export class DiscoveryRuntime implements DiscoveryRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient
  private cache: { services: ServiceEndpoint[]; capabilities: CapabilityManifest[]; lastSync: Date | null } | null = null

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async discover(options?: { ttl?: number; forceRefresh?: boolean }): Promise<ServiceEndpoint[]> {
    if (this.cache && !options?.forceRefresh) {
      const ttl = options?.ttl ?? 60000
      if (this.cache.lastSync && Date.now() - this.cache.lastSync.getTime() < ttl) {
        return this.cache.services
      }
    }

    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'DISCOVERY.SERVICES',
      payload: {},
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_DESCOBRIR_SERVICOS')
    }

    const services = response.resultado as ServiceEndpoint[]
    this.cache = { services, capabilities: this.cache?.capabilities ?? [], lastSync: new Date() }
    this.events?.track({ modulo: 'KERNEL', acao: 'DISCOVERY_SYNC_COMPLETED', payload: { services } })
    return services
  }

  async register(endpoint: ServiceEndpoint): Promise<void> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'DISCOVERY.REGISTER',
      payload: { endpoint },
      idSessao: 0
    })

    if (!response.sucesso) {
      throw new Error(response.mensagem ?? 'FALHA_REGISTRAR_ENDPOINT')
    }

    this.events?.track({ modulo: 'KERNEL', acao: 'DISCOVERY_ENDPOINT_REGISTERED', payload: { endpoint } })
  }

  async listCapabilities(options?: { ttl?: number; forceRefresh?: boolean }): Promise<CapabilityManifest[]> {
    if (this.cache && !options?.forceRefresh) {
      const ttl = options?.ttl ?? 60000
      if (this.cache.lastSync && Date.now() - this.cache.lastSync.getTime() < ttl) {
        return this.cache.capabilities
      }
    }

    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'DISCOVERY.CAPABILITIES',
      payload: {},
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_LISTAR_CAPABILITIES')
    }

    const capabilities = response.resultado as CapabilityManifest[]
    this.cache = { services: this.cache?.services ?? [], capabilities, lastSync: new Date() }
    this.events?.track({ modulo: 'KERNEL', acao: 'DISCOVERY_CAPABILITY_DISCOVERED', payload: { capabilities } })
    return capabilities
  }

  getEndpoint(service: string, method: string): ServiceEndpoint | undefined {
    return this.cache?.services.find(
      (s) => s.service === service && s.method.toLowerCase() === method.toLowerCase()
    )
  }

  compose(): DiscoveryRuntimeState {
    return {
      services: this.cache?.services ?? [],
      capabilities: this.cache?.capabilities ?? [],
      loading: false,
      error: null,
      lastSync: this.cache?.lastSync ?? null
    }
  }
}
