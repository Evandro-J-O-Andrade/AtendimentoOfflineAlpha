import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type {
  SessionId,
  SessionState,
  SessionRuntimeState,
  SessionEventType,
  SessionRuntimeMethods
} from './contracts/SessionContracts'

/**
 * Runtime de Session do Kernel Enterprise (MD-KERNEL-003).
 *
 * @fileoverview Implementação canônica do SessionRuntime.
 */
export class SessionRuntime implements SessionRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async create(payload: Record<string, unknown>): Promise<SessionState> {
    const response = await this.dispatcher.send({
      modulo: 'AUTH',
      acao: 'SESSION.CREATE',
      payload,
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_CRIAR_SESSAO')
    }

    const session = response.resultado as SessionState
    this.emitEvent('SESSION_CREATED', { id_sessao: session.idSessao, id_usuario: session.idUsuario })
    return session
  }

  async validate(): Promise<SessionState | null> {
    const response = await this.dispatcher.send({
      modulo: 'AUTH',
      acao: 'SESSION.VALIDATE',
      payload: {},
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      this.emitEvent('SESSION_EXPIRED', {})
      return null
    }

    const session = response.resultado as SessionState
    this.emitEvent('SESSION_AUTHENTICATED', { id_sessao: session.idSessao })
    return session
  }

  async refresh(): Promise<SessionState | null> {
    const response = await this.dispatcher.send({
      modulo: 'AUTH',
      acao: 'SESSION.REFRESH',
      payload: {},
      idSessao: 0
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_RENOVAR_SESSAO')
    }

    const session = response.resultado as SessionState
    this.emitEvent('SESSION_STARTED', { id_sessao: session.idSessao })
    return session
  }

  async terminate(): Promise<void> {
    const response = await this.dispatcher.send({
      modulo: 'AUTH',
      acao: 'SESSION.CLOSE',
      payload: {},
      idSessao: 0
    })

    if (!response.sucesso) {
      throw new Error(response.mensagem ?? 'FALHA_ENCERRAR_SESSAO')
    }

    this.emitEvent('SESSION_CLOSED', {})
  }

  compose(data: Partial<SessionState> | null): SessionRuntimeState {
    const now = Date.now()

    return {
      session: data ? (data as SessionState) : undefined,
      loading: false,
      error: null,
      isAuthenticated: data?.authenticated ?? false,
      isExpired: data ? (data.expiresAt ?? 0) < now : false
    }
  }

  private emitEvent(acao: SessionEventType, payload: Record<string, unknown>): void {
    this.events?.track({ modulo: 'KERNEL', acao, payload })
  }
}
