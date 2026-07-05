export interface AtendimentoSumarioAlta {
  id: number;
  id_atendimento: number;
  id_medico_alta: number;
  motivo_internacao: string;
  resumo_clinico: string;
  procedimentos_realizados: string;
  orientacoes_pos_alta: string;
  medicamentos_receitados: string;
  data_alta: string;
  assinatura_hash: string;
  id_entidade: number;
}

export interface AtendimentoSumarioAltaCreate {
  motivo_internacao?: string;
  resumo_clinico?: string;
  procedimentos_realizados?: string;
  orientacoes_pos_alta?: string;
  medicamentos_receitados?: string;
  data_alta?: string;
  assinatura_hash?: string;
}

export interface AtendimentoSumarioAltaUpdate {
  motivo_internacao?: string;
  resumo_clinico?: string;
  procedimentos_realizados?: string;
  orientacoes_pos_alta?: string;
  medicamentos_receitados?: string;
  data_alta?: string;
  assinatura_hash?: string;
}
