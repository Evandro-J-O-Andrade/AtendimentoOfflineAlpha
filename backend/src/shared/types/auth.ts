export interface AuthLoginResponse {
  authenticated: boolean
  session?: {
    id_sessao_usuario: number
    id_usuario: number
    id_entidade: number
    id_unidade: number
    id_local: number
    id_perfil: number
    token_jwt: string
    refresh_token: string
    expira_em: Date
  }
  state: 'AUTHENTICATED' | 'ERROR'
  message?: string
}

export interface AuthSessionResponse {
  id_sessao_usuario: number
  id_usuario: number
  id_entidade: number
  id_unidade: number
  id_local: number
  id_perfil: number
  expira_em: Date
  ativo: number
}

export interface AuthContextResponse {
  unidades: Array<{ id_unidade: number; nome_unidade: string }>
  perfis: Array<{ id_perfil: number; nome_perfil: string; id_unidade: number }>
  salas: Array<{ id_sala: number; nome_sala: string; id_unidade: number }>
}

export interface AuthMenuResponse {
  modulos: Array<{
    modulo: string
    nome: string
    icone: string
    ordem: number
    flags: { ativo: number; externo: number; restrito: number }
    acoes: Array<{ codigo: string; nome: string; sp: string; ordem: number }>
  }>
}
