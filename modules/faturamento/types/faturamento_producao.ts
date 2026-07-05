export interface FaturamentoProducao {
  id: number;
  id_atendimento: number;
  codigo_procedimento: string;
  cbo_profissional: string;
  status_faturamento: string;
  criado_em: string;
  id_entidade: number;
}

export interface FaturamentoProducaoCreate {
  codigo_procedimento?: string;
  cbo_profissional?: string;
  status_faturamento?: string;
  criado_em?: string;
}

export interface FaturamentoProducaoUpdate {
  codigo_procedimento?: string;
  cbo_profissional?: string;
  status_faturamento?: string;
  criado_em?: string;
}
