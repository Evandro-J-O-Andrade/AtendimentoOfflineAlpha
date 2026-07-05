export interface PainelEventoStream {
  id_evento: number;
  dominio: string;
  tipo_evento: string;
  id_referencia: number;
  id_painel: number;
  id_lane: number;
  id_local: number;
  payload: Record<string, unknown>;
  processado: number;
  criado_em: string;
  id_entidade: number;
}

export interface PainelEventoStreamCreate {
  dominio?: string;
  tipo_evento?: string;
  payload?: Record<string, unknown>;
  processado?: number;
  criado_em?: string;
}

export interface PainelEventoStreamUpdate {
  dominio?: string;
  tipo_evento?: string;
  payload?: Record<string, unknown>;
  processado?: number;
  criado_em?: string;
}
