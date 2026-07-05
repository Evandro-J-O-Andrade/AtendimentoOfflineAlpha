export interface AssistencialSnapshotRuntime {
  id_snapshot: number;
  id_ffa: number;
  estado_runtime: string;
  hash_estado: string;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface AssistencialSnapshotRuntimeCreate {
  estado_runtime?: string;
  hash_estado?: string;
  criado_em?: string;
}

export interface AssistencialSnapshotRuntimeUpdate {
  estado_runtime?: string;
  hash_estado?: string;
  criado_em?: string;
}
