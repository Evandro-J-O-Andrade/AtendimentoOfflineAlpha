/**
 * @fileoverview Event bus local para rastreabilidade no frontend.
 * @module lib/LocalEventBus
 * @description Implementação simples de barramento de eventos local
 * para rastreabilidade e debug durante desenvolvimento.
 */

import type { EventPayload } from './DispatcherContracts'

export interface LocalEvent extends EventPayload {
  id: string
  timestamp: number
}

export class LocalEventBus {
  private events: LocalEvent[] = []
  private listeners: Set<(event: LocalEvent) => void> = new Set()

  emit(event: EventPayload): LocalEvent {
    const localEvent: LocalEvent = {
      id: crypto.randomUUID(),
      timestamp: Date.now(),
      ...event
    }

    this.events.push(localEvent)
    this.notify(localEvent)
    return localEvent
  }

  subscribe(listener: (event: LocalEvent) => void): () => void {
    this.listeners.add(listener)
    return () => {
      this.listeners.delete(listener)
    }
  }

  getHistory(): LocalEvent[] {
    return [...this.events]
  }

  clear(): void {
    this.events = []
  }

  private notify(event: LocalEvent): void {
    for (const listener of this.listeners) {
      listener(event)
    }
  }
}
