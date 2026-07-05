export interface LedgerEventoSincronizacao {
  id_evento: string;
  id_tenant: number;
  id_sistema: number;
  id_unidade: number;
  id_local_operacional: number;
  tipo_evento: string;
  subtipo_evento: string;
  payload_json: Record<string, unknown>;
  hash_integridade: string;
  origem_contexto: string;
  estado_sincronizacao: string;
  tentativas_sync: number;
  timestamp_evento: string;
  timestamp_registro: string;
  versao_schema: number;
  criado_em: string;
  id_entidade: number;
}

export interface LedgerEventoSincronizacaoCreate {
  tipo_evento?: string;
  subtipo_evento?: string;
  payload_json?: Record<string, unknown>;
  origem_contexto?: string;
  estado_sincronizacao?: string;
  tentativas_sync?: number;
  timestamp_evento?: string;
  timestamp_registro?: string;
  versao_schema?: number;
  criado_em?: string;
}

export interface LedgerEventoSincronizacaoUpdate {
  tipo_evento?: string;
  subtipo_evento?: string;
  payload_json?: Record<string, unknown>;
  origem_contexto?: string;
  estado_sincronizacao?: string;
  tentativas_sync?: number;
  timestamp_evento?: string;
  timestamp_registro?: string;
  versao_schema?: number;
  criado_em?: string;
}
