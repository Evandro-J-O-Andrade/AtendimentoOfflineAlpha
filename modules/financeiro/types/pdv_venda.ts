export interface PdvVenda {
  id_venda: number;
  id_estoque_local: number;
  id_cliente: number;
  id_codigo_universal: number;
  codigo: string;
  barcode: string;
  status: string;
  total_bruto: number;
  desconto: number;
  total_liquido: number;
  id_sessao_usuario: number;
  criado_em: string;
  pago_em: string;
  id_entidade: number;
}

export interface PdvVendaCreate {
  codigo?: string;
  barcode?: string;
  status?: string;
  total_bruto?: number;
  desconto?: number;
  criado_em?: string;
  pago_em?: string;
}

export interface PdvVendaUpdate {
  codigo?: string;
  barcode?: string;
  status?: string;
  total_bruto?: number;
  desconto?: number;
  criado_em?: string;
  pago_em?: string;
}
