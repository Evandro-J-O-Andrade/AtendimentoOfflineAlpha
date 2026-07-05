export interface AuditoriaEvento {
  id_auditoria: number;
  id_usuario: number;
  id_sessao_usuario: number;
  dominio: string;
  tipo_evento: string;
  id_referencia: number;
  payload: Record<string, unknown>;
  metadata: Record<string, unknown>;
  criado_em: string;
  status: string;
  id_entidade: number;
}

export interface AuditoriaEventoCreate {
  dominio?: string;
  tipo_evento?: string;
  payload?: Record<string, unknown>;
  metadata?: Record<string, unknown>;
  criado_em?: string;
  status?: string;
}

export interface AuditoriaEventoUpdate {
  dominio?: string;
  tipo_evento?: string;
  payload?: Record<string, unknown>;
  metadata?: Record<string, unknown>;
  criado_em?: string;
  status?: string;
}
