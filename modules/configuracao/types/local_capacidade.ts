export interface LocalCapacidade {
  id_local_capacidade: number;
  id_local: number;
  capacidade_maxima: number;
  ocupacao_atual: number;
  atualizado_em: string;
  id_entidade: number;
}

export interface LocalCapacidadeCreate {
  ocupacao_atual?: number;
  atualizado_em?: string;
}

export interface LocalCapacidadeUpdate {
  ocupacao_atual?: number;
  atualizado_em?: string;
}
