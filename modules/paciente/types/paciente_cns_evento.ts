export interface PacienteCnsEvento {
  id_evento: number;
  id_paciente_cns: number;
  id_sessao_usuario: number;
  evento: string;
  detalhe: string;
  payload_json: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface PacienteCnsEventoCreate {
  evento?: string;
  detalhe?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
}

export interface PacienteCnsEventoUpdate {
  evento?: string;
  detalhe?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
}
