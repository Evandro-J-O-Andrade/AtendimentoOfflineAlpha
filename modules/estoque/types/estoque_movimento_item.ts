export interface EstoqueMovimentoItem {
  id_movimento_item: number;
  id_movimento: number;
  id_produto: number;
  id_lote: number;
  quantidade: number;
  valor_unitario: number;
  id_ffa_item: number;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueMovimentoItemCreate {
  valor_unitario?: number;
  criado_em?: string;
}

export interface EstoqueMovimentoItemUpdate {
  valor_unitario?: number;
  criado_em?: string;
}
