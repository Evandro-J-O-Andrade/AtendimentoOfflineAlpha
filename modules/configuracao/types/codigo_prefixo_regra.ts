export interface CodigoPrefixoRegra {
  id_regra: number;
  tipo: string;
  id_unidade: number;
  id_local_operacional: number;
  prefixo5: string;
  ativo: number;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface CodigoPrefixoRegraCreate {
  tipo?: string;
  prefixo5?: string;
  ativo?: number;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface CodigoPrefixoRegraUpdate {
  tipo?: string;
  prefixo5?: string;
  ativo?: number;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
