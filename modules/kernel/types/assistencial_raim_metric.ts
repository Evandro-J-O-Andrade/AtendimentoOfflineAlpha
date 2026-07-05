export interface AssistencialRaimMetric {
  id_metric: number;
  id_sistema: number;
  id_unidade: number;
  fila_pressao: number;
  taxa_evasao: number;
  saturacao_leito: number;
  backlog_runtime: number;
  score_raim: number;
  alerta_recomendacao: string;
  criado_em: string;
  id_entidade: number;
}

export interface AssistencialRaimMetricCreate {
  fila_pressao?: number;
  taxa_evasao?: number;
  saturacao_leito?: number;
  backlog_runtime?: number;
  score_raim?: number;
  alerta_recomendacao?: string;
  criado_em?: string;
}

export interface AssistencialRaimMetricUpdate {
  fila_pressao?: number;
  taxa_evasao?: number;
  saturacao_leito?: number;
  backlog_runtime?: number;
  score_raim?: number;
  alerta_recomendacao?: string;
  criado_em?: string;
}
