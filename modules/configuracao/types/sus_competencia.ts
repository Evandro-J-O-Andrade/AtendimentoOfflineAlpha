export interface SusCompetencia {
  id_competencia: number;
  competencia: string;
  descricao: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface SusCompetenciaCreate {
  competencia?: string;
  descricao?: string;
  ativo?: number;
  criado_em?: string;
}

export interface SusCompetenciaUpdate {
  competencia?: string;
  descricao?: string;
  ativo?: number;
  criado_em?: string;
}
