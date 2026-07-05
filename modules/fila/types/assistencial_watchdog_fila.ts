export interface AssistencialWatchdogFila {
  id_watchdog: number;
  unidade: string;
  backlog_eventos: number;
  taxa_retry: number;
  estado_runtime: string;
  atualizado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface AssistencialWatchdogFilaCreate {
  backlog_eventos?: number;
  taxa_retry?: number;
  estado_runtime?: string;
  atualizado_em?: string;
}

export interface AssistencialWatchdogFilaUpdate {
  backlog_eventos?: number;
  taxa_retry?: number;
  estado_runtime?: string;
  atualizado_em?: string;
}
