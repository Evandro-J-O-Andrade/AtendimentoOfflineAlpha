/**
 * @fileoverview Contratos canônicos do IdentityRuntime.
 * @module kernel.runtimes.identity.contracts
 * @description Define tipos e interfaces do domínio Identity (MD-KERNEL-001).
 */

export type IdentityId = string | number

export interface PersonData {
  id: IdentityId
  nome: string
  documento: string
  email?: string
}

export interface UserData {
  id: IdentityId
  login: string
  senha_hash?: string
  ativo: boolean
  id_pessoa: IdentityId
}

export interface IdentityRuntimeState {
  person?: PersonData | null
  user?: UserData | null
  loading: boolean
  error?: string | null
}

export interface IdentityRuntimeMethods {
  loadPerson(idPessoa: IdentityId): Promise<PersonData>
  loadUser(idUsuario: IdentityId): Promise<UserData>
  isAuthenticated(): boolean
  compose(session: unknown): IdentityRuntimeState
}
