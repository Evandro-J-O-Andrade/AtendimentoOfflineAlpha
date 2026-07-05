export interface RuntimeConcurrencyGuard {
  id_guard: number;
  dominio_fluxo: string;
  id_recurso: string;
  versao_estado: number;
  token_execucao: string;
  hash_contexto: string;
  status_guard: string;
  criado_em: string;
  confirmado_em: string;
  id_entidade: number;
}

export interface RuntimeConcurrencyGuardCreate {
  dominio_fluxo?: string;
  versao_estado?: number;
  token_execucao?: string;
  hash_contexto?: string;
  status_guard?: string;
  criado_em?: string;
  confirmado_em?: string;
}

export interface RuntimeConcurrencyGuardUpdate {
  dominio_fluxo?: string;
  versao_estado?: number;
  token_execucao?: string;
  hash_contexto?: string;
  status_guard?: string;
  criado_em?: string;
  confirmado_em?: string;
}
