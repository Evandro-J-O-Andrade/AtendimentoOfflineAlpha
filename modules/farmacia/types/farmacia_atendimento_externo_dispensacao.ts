export interface FarmaciaAtendimentoExternoDispensacao {
  id_dispensacao: number;
  id_item: number;
  id_lote: number;
  id_local_estoque: number;
  quantidade: number;
  status: string;
  dispensado_em: string;
  dispensado_por: number;
  observacao: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface FarmaciaAtendimentoExternoDispensacaoCreate {
  status?: string;
  dispensado_em?: string;
  dispensado_por?: number;
  observacao?: string;
}

export interface FarmaciaAtendimentoExternoDispensacaoUpdate {
  status?: string;
  dispensado_em?: string;
  dispensado_por?: number;
  observacao?: string;
}
