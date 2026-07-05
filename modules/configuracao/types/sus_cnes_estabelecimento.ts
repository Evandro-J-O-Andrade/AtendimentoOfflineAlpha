export interface SusCnesEstabelecimento {
  id_cnes: number;
  competencia: string;
  cnes: string;
  nome: string;
  municipio: string;
  uf: string;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface SusCnesEstabelecimentoCreate {
  competencia?: string;
  cnes?: string;
  nome?: string;
  municipio?: string;
  uf?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface SusCnesEstabelecimentoUpdate {
  competencia?: string;
  cnes?: string;
  nome?: string;
  municipio?: string;
  uf?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
