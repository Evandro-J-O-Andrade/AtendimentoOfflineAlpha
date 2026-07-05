export interface RuntimeSyncLog {
  id_sync: number;
  id_unidade: number;
  uuid_evento: string;
  tipo_evento: string;
  estado_payload: Record<string, unknown>;
  hash_payload: string;
  sincronizado: number;
  criado_em: string;
  id_entidade: number;
}

export interface RuntimeSyncLogCreate {
  tipo_evento?: string;
  estado_payload?: Record<string, unknown>;
  hash_payload?: string;
  sincronizado?: number;
  criado_em?: string;
}

export interface RuntimeSyncLogUpdate {
  tipo_evento?: string;
  estado_payload?: Record<string, unknown>;
  hash_payload?: string;
  sincronizado?: number;
  criado_em?: string;
}
