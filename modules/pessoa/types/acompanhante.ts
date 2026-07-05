export interface Acompanhante {
  id_acompanhante: number;
  id_pessoa: number;
  id_ffa: number;
  tipo: string;
  observacao: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface AcompanhanteCreate {
  tipo?: string;
  observacao?: string;
  ativo?: number;
  criado_em?: string;
}

export interface AcompanhanteUpdate {
  tipo?: string;
  observacao?: string;
  ativo?: number;
  criado_em?: string;
}
