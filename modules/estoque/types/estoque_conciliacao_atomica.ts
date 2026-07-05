export interface EstoqueConciliacaoAtomica {
  id: number;
  id_movimento: number;
  id_movimento_item: number;
  id_ledger: number;
  id_fluxo_assistencial: number;
  hash_execucao: string;
  estado_conciliacao: string;
  divergencia_quantidade: number;
  divergencia_valor: number;
  validado_em: string;
  criado_em: string;
  id_entidade: number;
}

export interface EstoqueConciliacaoAtomicaCreate {
  hash_execucao?: string;
  estado_conciliacao?: string;
  divergencia_valor?: number;
  criado_em?: string;
}

export interface EstoqueConciliacaoAtomicaUpdate {
  hash_execucao?: string;
  estado_conciliacao?: string;
  divergencia_valor?: number;
  criado_em?: string;
}
