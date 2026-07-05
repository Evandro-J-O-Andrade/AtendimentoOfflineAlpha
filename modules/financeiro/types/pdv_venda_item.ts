export interface PdvVendaItem {
  id_item: number;
  id_venda: number;
  id_produto: number;
  id_lote: number;
  quantidade: number;
  valor_unitario: number;
  valor_total: number;
  criado_em: string;
  id_entidade: number;
}

export interface PdvVendaItemCreate {
  valor_unitario?: number;
  valor_total?: number;
  criado_em?: string;
}

export interface PdvVendaItemUpdate {
  valor_unitario?: number;
  valor_total?: number;
  criado_em?: string;
}
