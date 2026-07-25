export interface LocalEvent {
  id: string
  timestamp: number
  modulo: string
  acao: string
  payload: Record<string, unknown>
  origem: string
  status: 'pending' | 'sent' | 'failed'
}

export interface EventClient {
  track(modulo: string, acao: string, payload: Record<string, unknown>): void
  getPending(): LocalEvent[]
  clear(): void
  subscribe(listener: (events: LocalEvent[]) => void): () => void
}

export class DefaultEventClient implements EventClient {
  private events: LocalEvent[] = []
  private listeners: Set<(events: LocalEvent[]) => void> = new Set()
  private readonly storageKey = '@platform/events/pending'

  constructor() {
    this.loadFromStorage()
  }

  track(modulo: string, acao: string, payload: Record<string, unknown>): void {
    const event: LocalEvent = {
      id: crypto.randomUUID(),
      timestamp: Date.now(),
      modulo,
      acao,
      payload,
      origem: 'frontend',
      status: 'pending'
    }

    this.events.push(event)
    this.persist()
    this.notify()
  }

  getPending(): LocalEvent[] {
    return this.events.filter((e) => e.status === 'pending')
  }

  clear(): void {
    this.events = []
    this.persist()
    this.notify()
  }

  markSent(ids: string[]): void {
    for (const event of this.events) {
      if (ids.includes(event.id)) {
        event.status = 'sent'
      }
    }
    this.persist()
    this.notify()
  }

  markFailed(ids: string[]): void {
    for (const event of this.events) {
      if (ids.includes(event.id)) {
        event.status = 'failed'
      }
    }
    this.persist()
    this.notify()
  }

  subscribe(listener: (events: LocalEvent[]) => void): () => void {
    this.listeners.add(listener)
    return () => {
      this.listeners.delete(listener)
    }
  }

  private persist(): void {
    if (typeof localStorage !== 'undefined') {
      localStorage.setItem(this.storageKey, JSON.stringify(this.events))
    }
  }

  private loadFromStorage(): void {
    if (typeof localStorage !== 'undefined') {
      const raw = localStorage.getItem(this.storageKey)
      if (raw) {
        try {
          this.events = JSON.parse(raw)
        } catch {
          this.events = []
        }
      }
    }
  }

  private notify(): void {
    for (const listener of this.listeners) {
      listener([...this.events])
    }
  }
}
