export interface CatEvento {
  id_cat_evento: number;
  id_cat: number;
  id_sessao_usuario: number;
  evento: string;
  payload_json: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface CatEventoCreate {
  evento?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
}

export interface CatEventoUpdate {
  evento?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
}
