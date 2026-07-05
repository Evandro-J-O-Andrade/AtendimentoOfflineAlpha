export interface FarmaciaDispensacaoLog {
  id: number;
  id_prescricao_item: number;
  id_sessao_usuario: number;
  id_lote: number;
  quantidade: number;
  criado_em: string;
  id_entidade: number;
}

export interface FarmaciaDispensacaoLogCreate {
  criado_em?: string;
}

export interface FarmaciaDispensacaoLogUpdate {
  criado_em?: string;
}
