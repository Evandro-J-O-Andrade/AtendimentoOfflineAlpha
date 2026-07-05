export interface SusSigtapProcedimento {
  id_sigtap: number;
  competencia: string;
  codigo: string;
  descricao: string;
  descricao_completa: string;
  grupo: string;
  subgrupo: string;
  forma_organizacao: string;
  complexidade: string;
  sexo: string;
  idade_min: number;
  idade_max: number;
  exige_cat_default: number;
  exige_sinan_default: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface SusSigtapProcedimentoCreate {
  competencia?: string;
  codigo?: string;
  descricao?: string;
  descricao_completa?: string;
  grupo?: string;
  subgrupo?: string;
  forma_organizacao?: string;
  sexo?: string;
  exige_cat_default?: number;
  exige_sinan_default?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface SusSigtapProcedimentoUpdate {
  competencia?: string;
  codigo?: string;
  descricao?: string;
  descricao_completa?: string;
  grupo?: string;
  subgrupo?: string;
  forma_organizacao?: string;
  sexo?: string;
  exige_cat_default?: number;
  exige_sinan_default?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
