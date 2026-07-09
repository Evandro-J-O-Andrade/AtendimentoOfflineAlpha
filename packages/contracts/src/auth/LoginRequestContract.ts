import type { AuthenticationState } from './AuthenticationState'
import type { AuthSessionContract } from './AuthSessionContract'

export interface LoginRequestContract {
  username: string
  password: string
  tenant?: string
  mfaCode?: string
}

export interface LoginResponseContract {
  authenticated: boolean
  session?: AuthSessionContract
  state: AuthenticationState
  message?: string
}
