import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type {
  RegistryEntry,
  RegistryRuntimeState,
  RegistryRuntimeMethods
} from './contracts/RegistryContracts'

/**
 * Runtime de Registry do Kernel Enterprise (MD-KERNEL-007).
 *
 * @fileoverview Implementação canônica do RegistryRuntime.
 */
export class RegistryRuntime implements RegistryRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient
  private entries: RegistryEntry[] = []

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async register(entry: RegistryEntry): Promise<void> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'REGISTRY.REGISTER',
      payload: { entry },
      idSessao: 0
    })

    if (!response.sucesso) {
      throw new Error(response.mensagem ?? 'FALHA_REGISTRAR_ENTRY')
    }

    this.entries.push(entry)
    this.events?.track({ modulo: 'KERNEL', acao: 'REGISTRY_ENTRY_REGISTERED', payload: { entry } })
  }

  async unregister(id: string): Promise<void> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'REGISTRY.UNREGISTER',
      payload: { id },
      idSessao: 0
    })

    if (!response.sucesso) {
      throw new Error(response.mensagem ?? 'FALHA_REMOVER_ENTRY')
    }

    this.entries = this.entries.filter((e) => e.id !== id)
    this.events?.track({ modulo: 'KERNEL', acao: 'REGISTRY_ENTRY_UNREGISTERED', payload: { id } })
  }

  async findByModulo(modulo: string): Promise<RegistryEntry[]> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'REGISTRY.FIND_BY_MODULE',
      payload: { modulo },
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      return this.entries.filter((e) => e.modulo === modulo)
    }

    return response.resultado as RegistryEntry[]
  }

  async findByAcao(modulo: string, acao: string): Promise<RegistryEntry | undefined> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'REGISTRY.FIND_BY_ACTION',
      payload: { modulo, acao },
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      return this.entries.find((e) => e.modulo === modulo && e.acao === acao)
    }

    return response.resultado as RegistryEntry
  }

  async list(): Promise<RegistryEntry[]> {
    if (this.entries.length > 0) {
      return [...this.entries]
    }

    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'REGISTRY.LIST',
      payload: {},
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      return []
    }

    this.entries = response.resultado as RegistryEntry[]
    return [...this.entries]
  }

  compose(_session: unknown): RegistryRuntimeState {
    const entries = [...this.entries]

    return {
      entries,
      loading: false,
      error: null,
      getEntry: (id: string) => entries.find((e) => e.id === id),
      findEntries: (modulo: string, acao?: string) =>
        entries.filter((e) => e.modulo === modulo && (!acao || e.acao === acao))
    }
  }
}
