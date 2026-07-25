/**
 * @fileoverview Contratos locais para integracao com o Dispatcher Enterprise.
 * @module lib/DispatcherContracts
 * @description Define interfaces canônicas de requisição e resposta do Dispatcher.
 */

export interface DispatcherRequest {
  modulo: string
  acao: string
  payload: Record<string, unknown>
  idSessao: number
}

export interface DispatcherResponse {
  sucesso: boolean
  resultado?: unknown
  mensagem?: string
}

export interface DispatcherClient {
  send(request: DispatcherRequest): Promise<DispatcherResponse>
}

export interface EventPayload {
  modulo: string
  acao: string
  payload: Record<string, unknown>
}

export interface EventClient {
  track(event: EventPayload): void
}
