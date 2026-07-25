/**
 * @fileoverview Contratos canônicos do EventRuntime.
 * @module kernel.runtimes.event.contracts
 * @description Define tipos e interfaces do domínio Event (MD-KERNEL-012).
 */

export type EventId = string
export type EventType = 'CRIACAO' | 'ATUALIZACAO' | 'EXECUCAO' | 'CANCELAMENTO' | 'SISTEMA'
export type EventOrigin = 'DISPATCHER' | 'EXECUTOR' | 'SISTEMA' | 'FRONTEND'

export interface KernelEvent {
  evento_uuid: EventId
  uuid_transacao: EventId
  dominio: string
  entidade_tipo: string
  entidade_id: string
  tipo_evento: EventType
  origem: EventOrigin
  payload: Record<string, unknown>
  timestamp: number
}

export interface EventQuery extends Record<string, unknown> {
  dominio?: string
  entidade_tipo?: string
  entidade_id?: string
  data_inicio?: number
  data_fim?: number
  origem?: EventOrigin
  tipo_evento?: EventType
}

export interface EventRuntimeState {
  events: KernelEvent[]
  loading: boolean
  error?: string | null
}

export interface EventRuntimeMethods {
  publish(event: Omit<KernelEvent, 'evento_uuid' | 'timestamp'>): Promise<KernelEvent>
  query(filtros: EventQuery): Promise<KernelEvent[]>
  replay(entidade_tipo: string, entidade_id: string): Promise<KernelEvent[]>
  subscribe(callback: (event: KernelEvent) => void): () => void
  compose(session: unknown): EventRuntimeState
}
