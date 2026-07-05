export interface EstoqueLote {
  id_lote: number;
  id_item: number;
  numero_lote: string;
  data_validade: string;
  id_sessao_usuario: number;
  id_entidade: number;
}

export interface EstoqueLoteCreate {
  numero_lote?: string;
}

export interface EstoqueLoteUpdate {
  numero_lote?: string;
}
