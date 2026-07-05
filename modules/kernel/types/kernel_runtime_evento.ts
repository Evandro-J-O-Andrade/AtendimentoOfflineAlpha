export interface KernelRuntimeEvento {
  id_evento: number;
  uuid_runtime: string;
  id_usuario: number;
  tipo_evento: string;
  entidade_alvo: string;
  id_referencia: number;
  payload: Record<string, unknown>;
  hash_evento: string;
  criado_em: string;
  id_entidade: number;
}

export interface KernelRuntimeEventoCreate {
  tipo_evento?: string;
  payload?: Record<string, unknown>;
  hash_evento?: string;
  criado_em?: string;
}

export interface KernelRuntimeEventoUpdate {
  tipo_evento?: string;
  payload?: Record<string, unknown>;
  hash_evento?: string;
  criado_em?: string;
}
