import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type { KernelEvent, EventRuntimeState, EventRuntimeMethods } from './contracts/EventContracts'

/**
 * Runtime de Event do Kernel Enterprise (MD-KERNEL-012).
 *
 * @fileoverview Implementação canônica do EventRuntime.
 */
export class EventRuntime implements EventRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient
  private localEvents: KernelEvent[] = []
  private listeners: Set<(event: KernelEvent) => void> = new Set()

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async publish(event: Omit<KernelEvent, 'evento_uuid' | 'timestamp'>): Promise<KernelEvent> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'EVENT.PUBLISH',
      payload: { event },
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_PUBLICAR_EVENTO')
    }

    const published = response.resultado as KernelEvent
    this.localEvents.push(published)
    this.notify(published)
    this.events?.track({ modulo: 'KERNEL', acao: 'EVENT_PUBLISHED', payload: { evento_uuid: published.evento_uuid } })
    return published
  }

  async query(filtros: Parameters<EventRuntimeMethods['query']>[0]): Promise<KernelEvent[]> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'EVENT.QUERY',
      payload: filtros,
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      return [...this.localEvents]
    }

    return response.resultado as KernelEvent[]
  }

  async replay(entidade_tipo: string, entidade_id: string): Promise<KernelEvent[]> {
    const response = await this.dispatcher.send({
      modulo: 'KERNEL',
      acao: 'EVENT.REPLAY',
      payload: { entidade_tipo, entidade_id },
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      return this.localEvents.filter((e) => e.entidade_tipo === entidade_tipo && e.entidade_id === entidade_id)
    }

    return response.resultado as KernelEvent[]
  }

  subscribe(callback: (event: KernelEvent) => void): () => void {
    this.listeners.add(callback)
    return () => {
      this.listeners.delete(callback)
    }
  }

  compose(_session: unknown): EventRuntimeState {
    return {
      events: [...this.localEvents],
      loading: false,
      error: null
    }
  }

  private notify(event: KernelEvent): void {
    for (const listener of this.listeners) {
      listener(event)
    }
  }
}
