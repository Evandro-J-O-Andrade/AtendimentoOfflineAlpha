export interface AssistencialRuntimePanel {
  id_panel: number;
  health_score_runtime: number;
  backlog_federado: number;
  retry_rate: number;
  hash_hit_rate: number;
  tombstone_hit_rate: number;
  divergencia_edge_nucleo: number;
  estado_runtime: string;
  alerta_preventivo: string;
  atualizado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface AssistencialRuntimePanelCreate {
  health_score_runtime?: number;
  backlog_federado?: number;
  retry_rate?: number;
  hash_hit_rate?: number;
  tombstone_hit_rate?: number;
  divergencia_edge_nucleo?: number;
  estado_runtime?: string;
  alerta_preventivo?: string;
  atualizado_em?: string;
}

export interface AssistencialRuntimePanelUpdate {
  health_score_runtime?: number;
  backlog_federado?: number;
  retry_rate?: number;
  hash_hit_rate?: number;
  tombstone_hit_rate?: number;
  divergencia_edge_nucleo?: number;
  estado_runtime?: string;
  alerta_preventivo?: string;
  atualizado_em?: string;
}
