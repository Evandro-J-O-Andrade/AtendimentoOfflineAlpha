import type { ApiClient } from '../index'
import type { LoginRequestContract, LoginResponseContract } from '@atendimentooffline/contracts'

export interface ContextResponse {
  unidades: Array<{ id_unidade: number; nome_unidade: string }>
  perfis: Array<{ id_perfil: number; nome_perfil: string; id_unidade: number }>
  salas: Array<{ id_sala: number; nome_sala: string; id_unidade: number }>
}

export interface AuthApi {
  login(request: LoginRequestContract): Promise<LoginResponseContract>
  session(idSessao: number): Promise<import('@atendimentooffline/contracts').AuthSessionContract>
  refresh(): Promise<import('@atendimentooffline/contracts').AuthSessionContract>
  logout(): Promise<void>
  context(idSessao: number): Promise<ContextResponse>
  selectContext(idSessao: number, idUnidade: number, idPerfil: number, idLocal?: number): Promise<{ success: boolean; session: import('@atendimentooffline/contracts').AuthSessionContract }>
}

export function createAuthApi(api: ApiClient): AuthApi {
  return {
    async login(request) {
      return api.post<LoginResponseContract>('/auth/login', request)
    },
    async session(idSessao: number) {
      return api.get(`/auth/session/${idSessao}`)
    },
    async refresh() {
      return api.post('/auth/refresh', {})
    },
    async logout() {
      return api.post<void>('/auth/logout', {})
    },
    async context(idSessao) {
      return api.get<ContextResponse>(`/auth/context/${idSessao}`)
    },
    async selectContext(idSessao, idUnidade, idPerfil, idLocal = 0) {
      return api.post(`/auth/context/select`, { id_sessao: idSessao, id_unidade: idUnidade, id_perfil: idPerfil, id_local: idLocal })
    }
  }
}
