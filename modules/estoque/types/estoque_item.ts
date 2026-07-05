export interface EstoqueItem {
  id_item: number;
  codigo_interno: string;
  codigo_barras: string;
  codigo_tuss: string;
  nome_comercial: string;
  categoria: string;
  unidade_venda: string;
  is_faturavel: number;
  id_sessao_usuario: number;
  id_entidade: number;
}

export interface EstoqueItemCreate {
  codigo_interno?: string;
  codigo_barras?: string;
  codigo_tuss?: string;
  nome_comercial?: string;
  categoria?: string;
  is_faturavel?: number;
}

export interface EstoqueItemUpdate {
  codigo_interno?: string;
  codigo_barras?: string;
  codigo_tuss?: string;
  nome_comercial?: string;
  categoria?: string;
  is_faturavel?: number;
}
