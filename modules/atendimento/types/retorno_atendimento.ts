export interface RetornoAtendimento {
  id_retorno: number;
  id_atendimento_origem: number;
  id_atendimento_retorno: number;
  motivo: string;
  data_hora: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface RetornoAtendimentoCreate {
  motivo?: string;
  data_hora?: string;
}

export interface RetornoAtendimentoUpdate {
  motivo?: string;
  data_hora?: string;
}
