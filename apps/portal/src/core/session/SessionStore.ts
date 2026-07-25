import { ApiDispatcherClient, type DispatcherClient } from '../api/DispatcherClient'
import type { DispatcherRequest } from '../contracts/DispatcherSchemas'

export interface SessionState {
  idSessao: number
  idUsuario: number
  idEntidade: number
  idUnidade: number
  idLocal: number
  idPerfil: number
  tokenJwt: string
  authenticated: boolean
}

export type SessionAction =
  | { type: 'LOGIN'; payload: SessionState }
  | { type: 'LOGOUT' }
  | { type: 'CONTEXT_SELECT'; payload: Partial<SessionState> }
  | { type: 'REFRESH'; payload: SessionState }

export class SessionStore {
  private state: SessionState | null = null
  private listeners: Array<(state: SessionState | null) => void> = []
  private readonly dispatcher: DispatcherClient

  constructor(dispatcher: DispatcherClient) {
    this.dispatcher = dispatcher
  }

  get current(): SessionState | null {
    return this.state
  }

  get authenticated(): boolean {
    return Boolean(this.state?.authenticated)
  }

  subscribe(listener: (state: SessionState | null) => void): () => void {
    this.listeners.push(listener)
    return () => {
      this.listeners = this.listeners.filter((l) => l !== listener)
    }
  }

  private emit(): void {
    for (const listener of this.listeners) {
      listener(this.state)
    }
  }

  login(session: SessionState): void {
    this.state = session
    this.emit()
  }

  logout(): void {
    this.state = null
    this.emit()
  }

  async selectContext(idUnidade: number, idPerfil: number, idLocal = 0): Promise<void> {
    if (!this.state) {
      throw new Error('SESSAO_INATIVA')
    }

    const response = await this.dispatcher.send({
      modulo: 'AUTH',
      acao: 'CONTEXT.SELECT',
      payload: { id_unidade: idUnidade, id_perfil: idPerfil, id_local: idLocal },
      idSessao: this.state.idSessao
    })

    const data = response.resultado as Partial<SessionState>
    this.state = { ...this.state, ...data, idUnidade, idPerfil, idLocal }
    this.emit()
  }

  async refresh(): Promise<void> {
    if (!this.state) {
      throw new Error('SESSAO_INATIVA')
    }

    const response = await this.dispatcher.send({
      modulo: 'AUTH',
      acao: 'SESSION.REFRESH',
      payload: {},
      idSessao: this.state.idSessao
    })

    const data = response.resultado as SessionState
    this.state = data
    this.emit()
  }
}
