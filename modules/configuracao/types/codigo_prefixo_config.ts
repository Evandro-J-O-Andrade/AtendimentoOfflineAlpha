export interface CodigoPrefixoConfig {
  id_prefixo: number;
  dominio: string;
  prefixo_5: string;
  id_unidade: number;
  id_local_operacional: number;
  id_laboratorio: number;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface CodigoPrefixoConfigCreate {
  dominio?: string;
  prefixo_5?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface CodigoPrefixoConfigUpdate {
  dominio?: string;
  prefixo_5?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
