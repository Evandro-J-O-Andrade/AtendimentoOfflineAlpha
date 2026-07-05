export interface VendaItem {
  id_venda_item: number;
  id_venda: number;
  id_farmaco: number;
  id_lote: number;
  id_local_estoque: number;
  descricao: string;
  quantidade: number;
  valor_unitario: number;
  desconto: number;
  total_linha: number;
  id_entidade: number;
}

export interface VendaItemCreate {
  descricao?: string;
  valor_unitario?: number;
  desconto?: number;
  total_linha?: number;
}

export interface VendaItemUpdate {
  descricao?: string;
  valor_unitario?: number;
  desconto?: number;
  total_linha?: number;
}
