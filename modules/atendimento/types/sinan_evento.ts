export interface SinanEvento {
  id_sinan_evento: number;
  id_sinan: number;
  id_sessao_usuario: number;
  evento: string;
  payload_json: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface SinanEventoCreate {
  evento?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
}

export interface SinanEventoUpdate {
  evento?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
}
