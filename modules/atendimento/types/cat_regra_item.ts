export interface CatRegraItem {
  id_cat_regra: number;
  codigo_sigtap: string;
  descricao: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface CatRegraItemCreate {
  codigo_sigtap?: string;
  descricao?: string;
  ativo?: number;
  criado_em?: string;
}

export interface CatRegraItemUpdate {
  codigo_sigtap?: string;
  descricao?: string;
  ativo?: number;
  criado_em?: string;
}
