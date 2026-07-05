export interface RhEvento {
  id_evento: number;
  id_rh_vinculo: number;
  id_registro: number;
  id_sessao_usuario: number;
  evento: string;
  detalhe: string;
  payload_json: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface RhEventoCreate {
  evento?: string;
  detalhe?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
}

export interface RhEventoUpdate {
  evento?: string;
  detalhe?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
}
