export interface AssistencialQuorumClinico {
  id_quorum: number;
  id_ffa: number;
  evento: string;
  total_unidades_participantes: number;
  unidades_confirmadas: number;
  quorum_valido: number;
  criado_em: string;
  id_entidade: number;
}

export interface AssistencialQuorumClinicoCreate {
  evento?: string;
  criado_em?: string;
}

export interface AssistencialQuorumClinicoUpdate {
  evento?: string;
  criado_em?: string;
}
