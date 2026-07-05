export interface AssistencialRuntimeFederado {
  id_snapshot: number;
  id_sistema: number;
  hash_runtime: string;
  payload_json: Record<string, unknown>;
  sincronizado: number;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface AssistencialRuntimeFederadoCreate {
  hash_runtime?: string;
  payload_json?: Record<string, unknown>;
  sincronizado?: number;
  criado_em?: string;
}

export interface AssistencialRuntimeFederadoUpdate {
  hash_runtime?: string;
  payload_json?: Record<string, unknown>;
  sincronizado?: number;
  criado_em?: string;
}
