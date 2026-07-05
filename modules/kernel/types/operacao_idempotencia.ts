export interface OperacaoIdempotencia {
  token: string;
  procedimento: string;
  referencia_id: number;
  criado_em: string;
  resultado: Record<string, unknown>;
  id_entidade: number;
}

export interface OperacaoIdempotenciaCreate {
  token?: string;
  procedimento?: string;
  criado_em?: string;
  resultado?: Record<string, unknown>;
}

export interface OperacaoIdempotenciaUpdate {
  token?: string;
  procedimento?: string;
  criado_em?: string;
  resultado?: Record<string, unknown>;
}
