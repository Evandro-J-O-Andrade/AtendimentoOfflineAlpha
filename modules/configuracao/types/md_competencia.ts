export interface MdCompetencia {
  competencia: string;
  descricao: string;
  dt_inicio: string;
  dt_fim: string;
  ativa: number;
  criado_em: string;
  id_entidade: number;
}

export interface MdCompetenciaCreate {
  competencia?: string;
  descricao?: string;
  dt_inicio?: string;
  dt_fim?: string;
  ativa?: number;
  criado_em?: string;
}

export interface MdCompetenciaUpdate {
  competencia?: string;
  descricao?: string;
  dt_inicio?: string;
  dt_fim?: string;
  ativa?: number;
  criado_em?: string;
}
