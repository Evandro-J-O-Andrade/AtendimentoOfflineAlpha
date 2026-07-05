export interface EstoqueLedger {
  id_ledger: number;
  id_movimento_item: number;
  id_conta: number;
  id_lote: number;
  tipo_dc: string;
  quantidade: number;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueLedgerCreate {
  tipo_dc?: string;
  criado_em?: string;
}

export interface EstoqueLedgerUpdate {
  tipo_dc?: string;
  criado_em?: string;
}
