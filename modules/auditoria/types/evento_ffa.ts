export interface EventoFfa {
  id_evento: number;
  id_ffa: number;
  id_paciente: number;
  id_usuario: number;
  origem: string;
  tipo_evento: string;
  status_origem: string;
  status_destino: string;
  payload: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface EventoFfaCreate {
  origem?: string;
  tipo_evento?: string;
  status_origem?: string;
  status_destino?: string;
  payload?: Record<string, unknown>;
  criado_em?: string;
}

export interface EventoFfaUpdate {
  origem?: string;
  tipo_evento?: string;
  status_origem?: string;
  status_destino?: string;
  payload?: Record<string, unknown>;
  criado_em?: string;
}
