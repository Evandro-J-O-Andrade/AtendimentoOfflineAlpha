export interface UsuarioRefresh {
  id_refresh: number;
  id_usuario: number;
  token_hash: string;
  expires_at: string;
  created_at: string;
  revoked: number;
  user_agent: string;
  ip: string;
  id_entidade: number;
}

export interface UsuarioRefreshCreate {
  token_hash?: string;
  expires_at?: string;
  created_at?: string;
  revoked?: number;
  user_agent?: string;
  ip?: string;
}

export interface UsuarioRefreshUpdate {
  token_hash?: string;
  expires_at?: string;
  created_at?: string;
  revoked?: number;
  user_agent?: string;
  ip?: string;
}
