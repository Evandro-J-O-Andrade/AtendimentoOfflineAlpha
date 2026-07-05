export interface AtendimentoMovimentacao {
  id_mov: number;
  id_atendimento: number;
  de_local: number;
  para_local: number;
  id_usuario: number;
  motivo: string;
  data_hora: string;
  id_entidade: number;
}

export interface AtendimentoMovimentacaoCreate {
  de_local?: number;
  para_local?: number;
  motivo?: string;
  data_hora?: string;
}

export interface AtendimentoMovimentacaoUpdate {
  de_local?: number;
  para_local?: number;
  motivo?: string;
  data_hora?: string;
}
