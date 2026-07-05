export interface AtendimentoDesfecho {
  id_desfecho: number;
  id_atendimento: number;
  tipo_desfecho: string;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface AtendimentoDesfechoCreate {
  tipo_desfecho?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface AtendimentoDesfechoUpdate {
  tipo_desfecho?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
