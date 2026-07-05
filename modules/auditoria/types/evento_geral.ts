export interface EventoGeral {
  id_evento: number;
  id_usuario: number;
  id_unidade: number;
  dominio: string;
  tipo_evento: string;
  id_referencia: number;
  payload: Record<string, unknown>;
  metadata: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface EventoGeralCreate {
  dominio?: string;
  tipo_evento?: string;
  payload?: Record<string, unknown>;
  metadata?: Record<string, unknown>;
  criado_em?: string;
}

export interface EventoGeralUpdate {
  dominio?: string;
  tipo_evento?: string;
  payload?: Record<string, unknown>;
  metadata?: Record<string, unknown>;
  criado_em?: string;
}
