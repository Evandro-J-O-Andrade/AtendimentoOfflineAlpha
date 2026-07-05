export interface AtendimentoEventoLedger {
  id_evento: number;
  uuid_transacao: string;
  uuid_transacao_pai: string;
  sequencia_evento: number;
  id_usuario: number;
  id_sessao: number;
  id_perfil: number;
  nome_usuario: string;
  acao: string;
  modulo: string;
  sub_modulo: string;
  estado_origem: string;
  estado_destino: string;
  estado_anterior: Record<string, unknown>;
  estado_novo: Record<string, unknown>;
  payload_original: Record<string, unknown>;
  payload_processado: Record<string, unknown>;
  id_atendimento: number;
  status_evento: string;
  codigo_erro: string;
  mensagem: string;
  ip_origem: string;
  user_agent: string;
  hostname: string;
  processing_time_ms: number;
  created_at: string;
  id_entidade: number;
}

export interface AtendimentoEventoLedgerCreate {
  sequencia_evento?: number;
  nome_usuario?: string;
  acao?: string;
  modulo?: string;
  sub_modulo?: string;
  estado_origem?: string;
  estado_destino?: string;
  estado_anterior?: Record<string, unknown>;
  estado_novo?: Record<string, unknown>;
  payload_original?: Record<string, unknown>;
  payload_processado?: Record<string, unknown>;
  status_evento?: string;
  codigo_erro?: string;
  mensagem?: string;
  ip_origem?: string;
  user_agent?: string;
  hostname?: string;
  processing_time_ms?: number;
  created_at?: string;
}

export interface AtendimentoEventoLedgerUpdate {
  sequencia_evento?: number;
  nome_usuario?: string;
  acao?: string;
  modulo?: string;
  sub_modulo?: string;
  estado_origem?: string;
  estado_destino?: string;
  estado_anterior?: Record<string, unknown>;
  estado_novo?: Record<string, unknown>;
  payload_original?: Record<string, unknown>;
  payload_processado?: Record<string, unknown>;
  status_evento?: string;
  codigo_erro?: string;
  mensagem?: string;
  ip_origem?: string;
  user_agent?: string;
  hostname?: string;
  processing_time_ms?: number;
  created_at?: string;
}
