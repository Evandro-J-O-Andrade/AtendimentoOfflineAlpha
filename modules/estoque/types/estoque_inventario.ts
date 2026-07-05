export interface EstoqueInventario {
  id_inventario: number;
  id_estoque_local: number;
  id_codigo_universal: number;
  codigo: string;
  barcode: string;
  status: string;
  id_sessao_usuario_abertura: number;
  aberto_em: string;
  fechado_em: string;
  observacao: string;
  id_entidade: number;
}

export interface EstoqueInventarioCreate {
  codigo?: string;
  barcode?: string;
  status?: string;
  aberto_em?: string;
  fechado_em?: string;
  observacao?: string;
}

export interface EstoqueInventarioUpdate {
  codigo?: string;
  barcode?: string;
  status?: string;
  aberto_em?: string;
  fechado_em?: string;
  observacao?: string;
}
