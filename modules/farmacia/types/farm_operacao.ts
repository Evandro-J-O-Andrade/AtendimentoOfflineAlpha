export interface FarmOperacao {
  id_operacao: number;
  tipo_ambiente: string;
  tipo_operacao: string;
  exige_dupla_baixa: number;
  criado_em: string;
  id_entidade: number;
}

export interface FarmOperacaoCreate {
  tipo_ambiente?: string;
  tipo_operacao?: string;
  exige_dupla_baixa?: number;
  criado_em?: string;
}

export interface FarmOperacaoUpdate {
  tipo_ambiente?: string;
  tipo_operacao?: string;
  exige_dupla_baixa?: number;
  criado_em?: string;
}
