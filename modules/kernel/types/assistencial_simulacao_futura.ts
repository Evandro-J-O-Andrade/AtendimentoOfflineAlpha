export interface AssistencialSimulacaoFutura {
  id_simulacao: number;
  horizonte_minutos: number;
  carga_prevista: number;
  risco_conflito_federado: number;
  risco_backlog: number;
  recomendacao_runtime: string;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface AssistencialSimulacaoFuturaCreate {
  horizonte_minutos?: number;
  carga_prevista?: number;
  risco_conflito_federado?: number;
  risco_backlog?: number;
  recomendacao_runtime?: string;
  criado_em?: string;
}

export interface AssistencialSimulacaoFuturaUpdate {
  horizonte_minutos?: number;
  carga_prevista?: number;
  risco_conflito_federado?: number;
  risco_backlog?: number;
  recomendacao_runtime?: string;
  criado_em?: string;
}
