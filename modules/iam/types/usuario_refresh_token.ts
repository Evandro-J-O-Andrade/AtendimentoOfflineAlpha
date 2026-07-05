export interface UsuarioRefreshToken {
  id_token: number;
  id_usuario: number;
  token: string;
  expira_em: string;
  revogado: number;
  criado_em: string;
  id_entidade: number;
}

export interface UsuarioRefreshTokenCreate {
  token?: string;
  expira_em?: string;
  revogado?: number;
  criado_em?: string;
}

export interface UsuarioRefreshTokenUpdate {
  token?: string;
  expira_em?: string;
  revogado?: number;
  criado_em?: string;
}
