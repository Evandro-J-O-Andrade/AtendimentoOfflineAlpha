export interface SessaoEvento {
  id_evento: number;
  id_sessao_usuario: number;
  id_usuario: number;
  tipo_evento: string;
  recurso: string;
  payload: Record<string, unknown>;
  ip_origem: string;
  criado_em: string;
  id_entidade: number;
}

export interface SessaoEventoCreate {
  tipo_evento?: string;
  recurso?: string;
  payload?: Record<string, unknown>;
  ip_origem?: string;
  criado_em?: string;
}

export interface SessaoEventoUpdate {
  tipo_evento?: string;
  recurso?: string;
  payload?: Record<string, unknown>;
  ip_origem?: string;
  criado_em?: string;
}
