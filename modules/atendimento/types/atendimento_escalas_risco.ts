export interface AtendimentoEscalasRisco {
  id: number;
  id_atendimento: number;
  id_usuario: number;
  escala_tipo: string;
  pontuacao_total: number;
  classificacao_resultado: string;
  data_avaliacao: string;
  id_entidade: number;
}

export interface AtendimentoEscalasRiscoCreate {
  escala_tipo?: string;
  pontuacao_total?: number;
  classificacao_resultado?: string;
  data_avaliacao?: string;
}

export interface AtendimentoEscalasRiscoUpdate {
  escala_tipo?: string;
  pontuacao_total?: number;
  classificacao_resultado?: string;
  data_avaliacao?: string;
}
