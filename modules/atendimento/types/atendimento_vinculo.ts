export interface AtendimentoVinculo {
  id: number;
  id_ffa: number;
  id_atendimento: number;
  criado_em: string;
  id_entidade: number;
}

export interface AtendimentoVinculoCreate {
  criado_em?: string;
}

export interface AtendimentoVinculoUpdate {
  criado_em?: string;
}
