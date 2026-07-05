export interface LaboratorioProtocoloEvento {
  id_evento: number;
  id_laboratorio_protocolo: number;
  id_sessao_usuario: number;
  evento: string;
  detalhe: string;
  payload_json: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface LaboratorioProtocoloEventoCreate {
  evento?: string;
  detalhe?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
}

export interface LaboratorioProtocoloEventoUpdate {
  evento?: string;
  detalhe?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
}
