export interface FilaOperacional {
  id_fila: number;
  id_ffa: number;
  tipo: string;
  substatus: string;
  prioridade: string;
  data_entrada: string;
  entrada_original_em: string;
  nao_compareceu_em: string;
  retorno_permitido_ate: string;
  retorno_utilizado: number;
  retorno_em: string;
  data_inicio: string;
  reavaliar_em: string;
  data_fim: string;
  id_responsavel: number;
  observacao: string;
  id_local: number;
  id_local_operacional: number;
  id_entidade: number;
}

export interface FilaOperacionalCreate {
  tipo?: string;
  substatus?: string;
  data_entrada?: string;
  entrada_original_em?: string;
  nao_compareceu_em?: string;
  retorno_utilizado?: number;
  retorno_em?: string;
  data_inicio?: string;
  reavaliar_em?: string;
  data_fim?: string;
  observacao?: string;
}

export interface FilaOperacionalUpdate {
  tipo?: string;
  substatus?: string;
  data_entrada?: string;
  entrada_original_em?: string;
  nao_compareceu_em?: string;
  retorno_utilizado?: number;
  retorno_em?: string;
  data_inicio?: string;
  reavaliar_em?: string;
  data_fim?: string;
  observacao?: string;
}
