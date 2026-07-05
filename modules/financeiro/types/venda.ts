export interface Venda {
  id_venda: number;
  id_caixa: number;
  id_cliente: number;
  origem: string;
  status: string;
  total_itens: number;
  total_desconto: number;
  total_final: number;
  criado_em: string;
  pago_em: string;
  cancelado_em: string;
  criado_por: number;
  id_entidade: number;
}

export interface VendaCreate {
  origem?: string;
  status?: string;
  total_itens?: number;
  total_desconto?: number;
  total_final?: number;
  criado_em?: string;
  pago_em?: string;
  cancelado_em?: string;
  criado_por?: number;
}

export interface VendaUpdate {
  origem?: string;
  status?: string;
  total_itens?: number;
  total_desconto?: number;
  total_final?: number;
  criado_em?: string;
  pago_em?: string;
  cancelado_em?: string;
  criado_por?: number;
}
