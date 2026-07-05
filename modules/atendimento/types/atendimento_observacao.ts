export interface AtendimentoObservacao {
  id_obs: number;
  id_atendimento: number;
  tipo: string;
  id_leito: number;
  data_inicio: string;
  data_fim: string;
  status: string;
  id_entidade: number;
}

export interface AtendimentoObservacaoCreate {
  tipo?: string;
  data_inicio?: string;
  data_fim?: string;
  status?: string;
}

export interface AtendimentoObservacaoUpdate {
  tipo?: string;
  data_inicio?: string;
  data_fim?: string;
  status?: string;
}
