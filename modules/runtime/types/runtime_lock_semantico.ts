export interface RuntimeLockSemantico {
  id_lock: number;
  dominio_fluxo: string;
  id_recurso: string;
  id_sessao_usuario: number;
  token_lock: string;
  expiracao_lock: string;
  criado_em: string;
  id_entidade: number;
}

export interface RuntimeLockSemanticoCreate {
  dominio_fluxo?: string;
  token_lock?: string;
  expiracao_lock?: string;
  criado_em?: string;
}

export interface RuntimeLockSemanticoUpdate {
  dominio_fluxo?: string;
  token_lock?: string;
  expiracao_lock?: string;
  criado_em?: string;
}
