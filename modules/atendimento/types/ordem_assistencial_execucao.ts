export interface OrdemAssistencialExecucao {
  id_execucao: number;
  id_item: number;
  id_aprazamento: number;
  acao: string;
  quantidade: number;
  realizado_em: string;
  id_usuario: number;
  id_sessao_usuario: number;
  id_local_operacional: number;
  observacao: string;
  payload: Record<string, unknown>;
  id_atendimento: number;
  id_entidade: number;
}

export interface OrdemAssistencialExecucaoCreate {
  acao?: string;
  realizado_em?: string;
  observacao?: string;
  payload?: Record<string, unknown>;
}

export interface OrdemAssistencialExecucaoUpdate {
  acao?: string;
  realizado_em?: string;
  observacao?: string;
  payload?: Record<string, unknown>;
}
