import type { PersonContract } from '../identity/PersonContract'
import type { UserContract } from '../identity/UserContract'

export interface AuthSessionContract {
  authenticated: boolean
  id_sessao_usuario?: number
  id_usuario?: number
  id_entidade?: number
  id_unidade?: number
  id_local?: number
  id_perfil?: number
  token_jwt?: string
  refresh_token?: string
  expira_em?: string
  person?: PersonContract
  user?: UserContract
  expiresAt?: string
}
