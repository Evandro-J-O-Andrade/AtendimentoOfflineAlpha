export interface AssistencialMinipalMetric {
  id_metric: number;
  id_sistema: number;
  id_unidade: number;
  score_global: number;
  risco_fila: number;
  risco_evasao: number;
  risco_retry: number;
  estabilidade_runtime: number;
  estado_rede: string;
  criado_em: string;
  id_entidade: number;
}

export interface AssistencialMinipalMetricCreate {
  score_global?: number;
  risco_fila?: number;
  risco_evasao?: number;
  risco_retry?: number;
  estado_rede?: string;
  criado_em?: string;
}

export interface AssistencialMinipalMetricUpdate {
  score_global?: number;
  risco_fila?: number;
  risco_evasao?: number;
  risco_retry?: number;
  estado_rede?: string;
  criado_em?: string;
}
