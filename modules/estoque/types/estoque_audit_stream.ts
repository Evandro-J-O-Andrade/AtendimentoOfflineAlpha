export interface EstoqueAuditStream {
  id_audit: number;
  id_referencia_externa: number;
  entidade_tipo: string;
  evento_tipo: string;
  payload: Record<string, unknown>;
  hash_pipeline: string;
  id_entidade: number;
}

export interface EstoqueAuditStreamCreate {
  evento_tipo?: string;
  payload?: Record<string, unknown>;
  hash_pipeline?: string;
}

export interface EstoqueAuditStreamUpdate {
  evento_tipo?: string;
  payload?: Record<string, unknown>;
  hash_pipeline?: string;
}
