export interface RuntimeEventoProvisional {
  id_provisional: number;
  uuid_evento: string;
  dominio_fluxo: string;
  payload_operacional: Record<string, unknown>;
  hash_snapshot: string;
  token_execucao: string;
  versao_estado: number;
  status_provisional: string;
  criado_em: string;
  sincronizado_em: string;
  id_entidade: number;
}

export interface RuntimeEventoProvisionalCreate {
  dominio_fluxo?: string;
  payload_operacional?: Record<string, unknown>;
  hash_snapshot?: string;
  token_execucao?: string;
  versao_estado?: number;
  status_provisional?: string;
  criado_em?: string;
  sincronizado_em?: string;
}

export interface RuntimeEventoProvisionalUpdate {
  dominio_fluxo?: string;
  payload_operacional?: Record<string, unknown>;
  hash_snapshot?: string;
  token_execucao?: string;
  versao_estado?: number;
  status_provisional?: string;
  criado_em?: string;
  sincronizado_em?: string;
}
