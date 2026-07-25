/**
 * @fileoverview Contratos canônicos do SessionRuntime.
 * @module kernel.runtimes.session.contracts
 * @description Define tipos, interfaces, eventos e métodos do domínio Session (MD-KERNEL-003).
 */

import type { IdentityId } from '../../identity/contracts/IdentityContracts'

export type SessionId = string | number

export type SessionEventType =
  | 'SESSION_CREATED'
  | 'SESSION_AUTHENTICATED'
  | 'SESSION_STARTED'
  | 'SESSION_EXPIRED'
  | 'SESSION_REVOKED'
  | 'SESSION_CLOSED'

export interface SessionState {
  idSessao: SessionId
  idUsuario: IdentityId
  idEntidade: IdentityId
  idUnidade: string
  idLocal: string
  idPerfil: string
  tokenJwt: string
  authenticated: boolean
  expiresAt: number
}

export interface SessionRuntimeState {
  session?: SessionState | null
  loading: boolean
  error?: string | null
  isAuthenticated: boolean
  isExpired: boolean
}

export interface SessionRuntimeMethods {
  create(payload: Record<string, unknown>): Promise<SessionState>
  validate(): Promise<SessionState | null>
  refresh(): Promise<SessionState | null>
  terminate(): Promise<void>
  compose(data: Partial<SessionState> | null): SessionRuntimeState
}
