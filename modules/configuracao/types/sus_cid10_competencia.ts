export interface SusCid10Competencia {
  id_cid10c: number;
  competencia: string;
  cid10: string;
  descricao: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface SusCid10CompetenciaCreate {
  competencia?: string;
  descricao?: string;
  ativo?: number;
  criado_em?: string;
}

export interface SusCid10CompetenciaUpdate {
  competencia?: string;
  descricao?: string;
  ativo?: number;
  criado_em?: string;
}
