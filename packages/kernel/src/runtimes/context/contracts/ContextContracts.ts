/**
 * @fileoverview Contratos canônicos do ContextRuntime.
 * @module kernel.runtimes.context.contracts
 * @description Define tipos e interfaces do domínio Context (MD-KERNEL-004).
 */

import type { SessionId } from '../../session/contracts/SessionContracts'

export type UnidadeId = string | number
export type LocalId = string | number
export type PerfilId = string | number

export type { SessionId } from '../../session/contracts/SessionContracts'

export interface UnidadeData {
  id: UnidadeId
  nome_unidade: string
}

export interface LocalData {
  id: LocalId
  nome_local: string
  id_unidade: UnidadeId
}

export interface PerfilData {
  id: PerfilId
  nome_perfil: string
  id_unidade: UnidadeId
}

export interface ContextSelection {
  idUnidade: UnidadeId
  idPerfil: PerfilId
  idLocal: LocalId
}

export interface ContextRuntimeState {
  unidades: UnidadeData[]
  perfis: PerfilData[]
  salas: LocalData[]
  selected?: ContextSelection | null
  loading: boolean
  error?: string | null
}

export interface ContextRuntimeMethods {
  loadUnidades(idSessao: SessionId): Promise<UnidadeData[]>
  loadPerfis(idSessao: SessionId, idUnidade: UnidadeId): Promise<PerfilData[]>
  loadLocais(idSessao: SessionId, idUnidade: UnidadeId): Promise<LocalData[]>
  selectContext(
    idSessao: SessionId,
    idUnidade: UnidadeId,
    idPerfil: PerfilId,
    idLocal: LocalId
  ): Promise<ContextSelection>
  compose(session: unknown): ContextRuntimeState
}
