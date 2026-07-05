export interface RuntimeApiSessionToken {
  id_token: number;
  id_usuario: number;
  uuid_runtime: string;
  token_hash: string;
  expira_em: string;
  device_id: string;
  tenant_id: number;
  ativo: number;
  criado_em: string;
  ultimo_acesso: string;
  id_entidade: number;
}

export interface RuntimeApiSessionTokenCreate {
  token_hash?: string;
  expira_em?: string;
  ativo?: number;
  criado_em?: string;
  ultimo_acesso?: string;
}

export interface RuntimeApiSessionTokenUpdate {
  token_hash?: string;
  expira_em?: string;
  ativo?: number;
  criado_em?: string;
  ultimo_acesso?: string;
}
