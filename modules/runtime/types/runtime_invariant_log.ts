export interface RuntimeInvariantLog {
  id_invariant: number;
  uuid_runtime: string;
  id_unidade: number;
  tipo_invariante: string;
  payload_original: Record<string, unknown>;
  hash_payload: string;
  estado_valido: number;
  criado_em: string;
  id_entidade: number;
}

export interface RuntimeInvariantLogCreate {
  tipo_invariante?: string;
  payload_original?: Record<string, unknown>;
  hash_payload?: string;
  criado_em?: string;
}

export interface RuntimeInvariantLogUpdate {
  tipo_invariante?: string;
  payload_original?: Record<string, unknown>;
  hash_payload?: string;
  criado_em?: string;
}
