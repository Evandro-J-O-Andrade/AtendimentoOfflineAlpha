export interface FfaPrioridade {
  id: number;
  id_ffa: number;
  codigo_prioridade: string;
  criado_em: string;
  ativo: number;
  id_entidade: number;
}

export interface FfaPrioridadeCreate {
  criado_em?: string;
  ativo?: number;
}

export interface FfaPrioridadeUpdate {
  criado_em?: string;
  ativo?: number;
}
