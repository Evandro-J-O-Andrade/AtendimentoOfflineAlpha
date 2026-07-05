export interface EstoqueLoteSnapshot {
  id_snapshot: number;
  id_lote: number;
  id_movimento_item: number;
  saldo_anterior: number;
  variacao: number;
  saldo_atual: number;
  hash_anterior: string;
  hash_atual: string;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueLoteSnapshotCreate {
  saldo_anterior?: number;
  variacao?: number;
  saldo_atual?: number;
  hash_anterior?: string;
  hash_atual?: string;
  criado_em?: string;
}

export interface EstoqueLoteSnapshotUpdate {
  saldo_anterior?: number;
  variacao?: number;
  saldo_atual?: number;
  hash_anterior?: string;
  hash_atual?: string;
  criado_em?: string;
}
