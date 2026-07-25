import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type {
  CapabilityData,
  CapabilityRuntimeState,
  CapabilityRuntimeMethods
} from './contracts/CapabilityContracts'

/**
 * Runtime de Capability do Kernel Enterprise (MD-KERNEL-008).
 *
 * @fileoverview Implementação canônica do CapabilityRuntime.
 */
export class CapabilityRuntime implements CapabilityRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient
  private capabilities: CapabilityData[] = []

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async list(): Promise<CapabilityData[]> {
    if (this.capabilities.length > 0) {
      return [...this.capabilities]
    }

    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'CAPABILITY.LIST',
      payload: {},
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_LISTAR_CAPABILITIES')
    }

    this.capabilities = response.resultado as CapabilityData[]
    return [...this.capabilities]
  }

  async enable(id: string): Promise<void> {
    await this.checkDependencies(id)

    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'CAPABILITY.ENABLE',
      payload: { id },
      idSessao: 0
    })

    if (!response.sucesso) {
      throw new Error(response.mensagem ?? 'FALHA_HABILITAR_CAPABILITY')
    }

    const capability = this.capabilities.find((c) => c.id === id)
    if (capability) {
      capability.enabled = true
    }

    this.events?.track({ modulo: 'KERNEL', acao: 'CAPABILITY_ENABLED', payload: { id } })
  }

  async disable(id: string): Promise<void> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'CAPABILITY.DISABLE',
      payload: { id },
      idSessao: 0
    })

    if (!response.sucesso) {
      throw new Error(response.mensagem ?? 'FALHA_DESABILITAR_CAPABILITY')
    }

    const capability = this.capabilities.find((c) => c.id === id)
    if (capability) {
      capability.enabled = false
    }

    this.events?.track({ modulo: 'KERNEL', acao: 'CAPABILITY_DISABLED', payload: { id } })
  }

  async checkDependencies(id: string): Promise<boolean> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'CAPABILITY.CHECK_DEPENDENCIES',
      payload: { id },
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      return false
    }

    const result = response.resultado as { satisfied: boolean }
    this.events?.track({ modulo: 'KERNEL', acao: 'CAPABILITY_DEPENDENCY_CHECKED', payload: { id, satisfied: result.satisfied } })
    return result.satisfied
  }

  compose(_session: unknown): CapabilityRuntimeState {
    const capabilities = [...this.capabilities]

    return {
      capabilities,
      loading: false,
      error: null,
      isEnabled: (id: string) => capabilities.some((c) => c.id === id && c.enabled),
      enable: async (id: string) => { await this.enable(id) },
      disable: async (id: string) => { await this.disable(id) }
    }
  }
}
