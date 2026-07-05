export interface AtendimentoBalancoHidrico {
  id: number;
  id_atendimento: number;
  tipo_movimentacao: string;
  via: string;
  volume_ml: number;
  id_usuario_registro: number;
  data_hora: string;
  id_entidade: number;
}

export interface AtendimentoBalancoHidricoCreate {
  tipo_movimentacao?: string;
  via?: string;
  volume_ml?: number;
  data_hora?: string;
}

export interface AtendimentoBalancoHidricoUpdate {
  tipo_movimentacao?: string;
  via?: string;
  volume_ml?: number;
  data_hora?: string;
}
