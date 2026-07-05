export interface FfaEstoqueConciliacao {
  id_conciliacao: number;
  id_ffa_item: number;
  id_movimento_item: number;
  valor_faturado: number;
  valor_custo: number;
  criado_em: string;
  id_entidade: number;
}

export interface FfaEstoqueConciliacaoCreate {
  valor_faturado?: number;
  valor_custo?: number;
  criado_em?: string;
}

export interface FfaEstoqueConciliacaoUpdate {
  valor_faturado?: number;
  valor_custo?: number;
  criado_em?: string;
}
