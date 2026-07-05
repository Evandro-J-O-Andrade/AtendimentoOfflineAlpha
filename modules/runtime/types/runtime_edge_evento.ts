export interface RuntimeEdgeEvento {
  id_evento: number;
  uuid_evento: string;
  id_sessao_usuario: number;
  id_unidade: number;
  id_local: number;
  dominio_fluxo: string;
  estado_origem: string;
  estado_destino: string;
  payload_operacional: Record<string, unknown>;
  metadata_snapshot_hash: string;
  modo_execucao: string;
  status_sync: string;
  criado_em: string;
  sincronizado_em: string;
  id_orquestrador: number;
  id_entidade: number;
}

export interface RuntimeEdgeEventoCreate {
  dominio_fluxo?: string;
  estado_origem?: string;
  estado_destino?: string;
  payload_operacional?: Record<string, unknown>;
  metadata_snapshot_hash?: string;
  modo_execucao?: string;
  status_sync?: string;
  criado_em?: string;
  sincronizado_em?: string;
}

export interface RuntimeEdgeEventoUpdate {
  dominio_fluxo?: string;
  estado_origem?: string;
  estado_destino?: string;
  payload_operacional?: Record<string, unknown>;
  metadata_snapshot_hash?: string;
  modo_execucao?: string;
  status_sync?: string;
  criado_em?: string;
  sincronizado_em?: string;
}
