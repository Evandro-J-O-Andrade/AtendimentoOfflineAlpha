export interface AuthToken {
  id_token: number;
  id_usuario: number;
  tipo_token: string;
  token_hash: string;
  ip_origem: string;
  user_agent: string;
  ativo: number;
  expira_em: string;
  criado_em: string;
  utilizado_em: string;
  id_entidade: number;
}

export interface AuthTokenCreate {
  tipo_token?: string;
  token_hash?: string;
  ip_origem?: string;
  user_agent?: string;
  ativo?: number;
  expira_em?: string;
  criado_em?: string;
  utilizado_em?: string;
}

export interface AuthTokenUpdate {
  tipo_token?: string;
  token_hash?: string;
  ip_origem?: string;
  user_agent?: string;
  ativo?: number;
  expira_em?: string;
  criado_em?: string;
  utilizado_em?: string;
}
