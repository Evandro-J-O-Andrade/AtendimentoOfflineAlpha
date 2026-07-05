export interface EstoqueMovimento {
  id_movimento: number;
  id_item: number;
  id_unidade: number;
  id_local_origem: number;
  id_local_destino: number;
  id_lote: number;
  tipo_movimento: string;
  quantidade: number;
  hash_duplicidade: string;
  id_sessao_usuario: number;
  id_entidade: number;
}

export interface EstoqueMovimentoCreate {
  tipo_movimento?: string;
}

export interface EstoqueMovimentoUpdate {
  tipo_movimento?: string;
}
