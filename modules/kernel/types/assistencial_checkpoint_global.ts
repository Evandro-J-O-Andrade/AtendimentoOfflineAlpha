export interface AssistencialCheckpointGlobal {
  id_checkpoint: number;
  id_ffa: number;
  estado_snapshot: string;
  quorum_valido: number;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface AssistencialCheckpointGlobalCreate {
  estado_snapshot?: string;
  criado_em?: string;
}

export interface AssistencialCheckpointGlobalUpdate {
  estado_snapshot?: string;
  criado_em?: string;
}
