export interface FaturamentoRegrasValidacao {
  id: number;
  id_atendimento: number;
  possui_cid: number;
  possui_cbo: number;
  possui_prescricao: number;
  apto_para_faturar: number;
  id_entidade: number;
}

export interface FaturamentoRegrasValidacaoCreate {
  possui_cbo?: number;
  possui_prescricao?: number;
  apto_para_faturar?: number;
}

export interface FaturamentoRegrasValidacaoUpdate {
  possui_cbo?: number;
  possui_prescricao?: number;
  apto_para_faturar?: number;
}
