export interface EstoqueProduto {
  id_produto: number;
  id_codigo_universal: number;
  sku_interno: string;
  barcode: string;
  nome: string;
  descricao: string;
  categoria: string;
  subcategoria: string;
  marca: string;
  id_unidade_medida: string;
  exige_lote: number;
  controlado: number;
  exige_receita: number;
  controlado_anvisa: number;
  registro_anvisa: string;
  curva_abc: string;
  estoque_minimo: number;
  estoque_maximo: number;
  ponto_reposicao: number;
  ativo: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueProdutoCreate {
  sku_interno?: string;
  barcode?: string;
  nome?: string;
  descricao?: string;
  categoria?: string;
  subcategoria?: string;
  marca?: string;
  exige_lote?: number;
  controlado?: number;
  exige_receita?: number;
  controlado_anvisa?: number;
  registro_anvisa?: string;
  curva_abc?: string;
  estoque_minimo?: number;
  estoque_maximo?: number;
  ponto_reposicao?: number;
  ativo?: number;
  criado_em?: string;
}

export interface EstoqueProdutoUpdate {
  sku_interno?: string;
  barcode?: string;
  nome?: string;
  descricao?: string;
  categoria?: string;
  subcategoria?: string;
  marca?: string;
  exige_lote?: number;
  controlado?: number;
  exige_receita?: number;
  controlado_anvisa?: number;
  registro_anvisa?: string;
  curva_abc?: string;
  estoque_minimo?: number;
  estoque_maximo?: number;
  ponto_reposicao?: number;
  ativo?: number;
  criado_em?: string;
}
