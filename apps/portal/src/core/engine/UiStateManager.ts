export type UiStateStatus = 'idle' | 'loading' | 'success' | 'error'

export interface UiState<T> {
  status: UiStateStatus
  data: T | null
  error: string | null
  lastUpdated: number
}

export interface UiStateManager {
  getState<T>(key: string): UiState<T>
  setLoading(key: string): void
  setSuccess<T>(key: string, data: T): void
  setError(key: string, error: string): void
  reset(key: string): void
}

export class DefaultUiStateManager implements UiStateManager {
  private states: Map<string, UiState<unknown>> = new Map()
  private listeners: Map<string, Set<(state: UiState<unknown>) => void>> = new Map()

  getState<T>(key: string): UiState<T> {
    const state = this.states.get(key)
    if (!state) {
      return {
        status: 'idle',
        data: null,
        error: null,
        lastUpdated: Date.now()
      }
    }
    return state as UiState<T>
  }

  setLoading(key: string): void {
    this.updateState(key, {
      status: 'loading',
      data: null,
      error: null,
      lastUpdated: Date.now()
    })
  }

  setSuccess<T>(key: string, data: T): void {
    this.updateState(key, {
      status: 'success',
      data,
      error: null,
      lastUpdated: Date.now()
    })
  }

  setError(key: string, error: string): void {
    this.updateState(key, {
      status: 'error',
      data: null,
      error,
      lastUpdated: Date.now()
    })
  }

  reset(key: string): void {
    this.updateState(key, {
      status: 'idle',
      data: null,
      error: null,
      lastUpdated: Date.now()
    })
  }

  subscribe(key: string, listener: (state: UiState<unknown>) => void): () => void {
    const listeners = this.listeners.get(key) ?? new Set()
    listeners.add(listener)
    this.listeners.set(key, listeners)

    return () => {
      const current = this.listeners.get(key)
      if (current) {
        current.delete(listener)
        if (current.size === 0) {
          this.listeners.delete(key)
        }
      }
    }
  }

  private updateState(key: string, state: UiState<unknown>): void {
    this.states.set(key, state)
    const listeners = this.listeners.get(key)
    if (listeners) {
      for (const listener of listeners) {
        listener(state)
      }
    }
  }
}
