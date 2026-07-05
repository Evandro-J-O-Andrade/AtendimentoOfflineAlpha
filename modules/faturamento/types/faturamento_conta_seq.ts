export interface FaturamentoContaSeq {
  id: number;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface FaturamentoContaSeqCreate {
  criado_em?: string;
}

export interface FaturamentoContaSeqUpdate {
  criado_em?: string;
}
