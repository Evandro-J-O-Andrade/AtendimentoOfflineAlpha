export interface RetrySemanticoControle {
  id_retry: number;
  id_ffa: number;
  evento: string;
  versao_logica: number;
  tentativas: number;
  max_tentativas: number;
  bloqueado: number;
  ultimo_erro: string;
  proxima_tentativa: string;
  criado_em: string;
  id_entidade: number;
}

export interface RetrySemanticoControleCreate {
  evento?: string;
  versao_logica?: number;
  tentativas?: number;
  max_tentativas?: number;
  bloqueado?: number;
  ultimo_erro?: string;
  proxima_tentativa?: string;
  criado_em?: string;
}

export interface RetrySemanticoControleUpdate {
  evento?: string;
  versao_logica?: number;
  tentativas?: number;
  max_tentativas?: number;
  bloqueado?: number;
  ultimo_erro?: string;
  proxima_tentativa?: string;
  criado_em?: string;
}
