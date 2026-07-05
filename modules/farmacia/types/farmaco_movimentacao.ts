export interface FarmacoMovimentacao {
  id_movimentacao: number;
  id_farmaco: number;
  id_lote: number;
  id_cidade: number;
  tipo: string;
  quantidade: number;
  origem: string;
  id_ffa: number;
  observacao: string;
  realizado_por: number;
  data_mov: string;
  id_entidade: number;
}

export interface FarmacoMovimentacaoCreate {
  tipo?: string;
  origem?: string;
  observacao?: string;
  realizado_por?: number;
  data_mov?: string;
}

export interface FarmacoMovimentacaoUpdate {
  tipo?: string;
  origem?: string;
  observacao?: string;
  realizado_por?: number;
  data_mov?: string;
}
