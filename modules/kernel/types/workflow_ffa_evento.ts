export interface WorkflowFfaEvento {
  id_workflow_evento: number;
  id_ffa: number;
  origem: string;
  entidade: string;
  id_entidade: number;
  tipo_evento: string;
  detalhe: string;
  id_sessao_usuario: number;
  criado_em: string;
  payload_json: Record<string, unknown>;
}

export interface WorkflowFfaEventoCreate {
  origem?: string;
  tipo_evento?: string;
  detalhe?: string;
  criado_em?: string;
  payload_json?: Record<string, unknown>;
}

export interface WorkflowFfaEventoUpdate {
  origem?: string;
  tipo_evento?: string;
  detalhe?: string;
  criado_em?: string;
  payload_json?: Record<string, unknown>;
}
