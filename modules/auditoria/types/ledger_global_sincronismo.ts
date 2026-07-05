export interface LedgerGlobalSincronismo {
  ulid_evento: string;
  id_tenant: number;
  id_sistema: number;
  id_unidade: number;
  id_local_operacional: number;
  origem_runtime: string;
  contexto_origem: string;
  tipo_evento: string;
  subtipo_evento: string;
  payload_json: Record<string, unknown>;
  hash_integridade: string;
  data_evento_local: string;
  data_evento_central: string;
  versao_schema: number;
  estado_processamento: string;
  tentativas_sync: number;
  criado_por: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface LedgerGlobalSincronismoCreate {
  origem_runtime?: string;
  contexto_origem?: string;
  tipo_evento?: string;
  subtipo_evento?: string;
  payload_json?: Record<string, unknown>;
  data_evento_local?: string;
  data_evento_central?: string;
  versao_schema?: number;
  estado_processamento?: string;
  tentativas_sync?: number;
  criado_por?: number;
  criado_em?: string;
}

export interface LedgerGlobalSincronismoUpdate {
  origem_runtime?: string;
  contexto_origem?: string;
  tipo_evento?: string;
  subtipo_evento?: string;
  payload_json?: Record<string, unknown>;
  data_evento_local?: string;
  data_evento_central?: string;
  versao_schema?: number;
  estado_processamento?: string;
  tentativas_sync?: number;
  criado_por?: number;
  criado_em?: string;
}
