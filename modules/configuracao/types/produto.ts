export interface Produto {
  id_produto: number;
  tipo_produto: string;
  categoria: string;
  subcategoria: string;
  nome: string;
  descricao_tecnica: string;
  unidade_medida: string;
  codigo_barras: string;
  codigo_interno: string;
  codigo_sigtap: string;
  codigo_gpat: string;
  criado_em: string;
  id_entidade: number;
}

export interface ProdutoCreate {
  tipo_produto?: string;
  categoria?: string;
  subcategoria?: string;
  nome?: string;
  descricao_tecnica?: string;
  codigo_barras?: string;
  codigo_interno?: string;
  codigo_sigtap?: string;
  codigo_gpat?: string;
  criado_em?: string;
}

export interface ProdutoUpdate {
  tipo_produto?: string;
  categoria?: string;
  subcategoria?: string;
  nome?: string;
  descricao_tecnica?: string;
  codigo_barras?: string;
  codigo_interno?: string;
  codigo_sigtap?: string;
  codigo_gpat?: string;
  criado_em?: string;
}
