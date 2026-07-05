export interface SinanNotificacao {
  id_sinan: number;
  id_ffa: number;
  id_gpat: number;
  id_usuario_responsavel: number;
  tipo_notificacao: string;
  status: string;
  payload_json: Record<string, unknown>;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface SinanNotificacaoCreate {
  tipo_notificacao?: string;
  status?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
  atualizado_em?: string;
}

export interface SinanNotificacaoUpdate {
  tipo_notificacao?: string;
  status?: string;
  payload_json?: Record<string, unknown>;
  criado_em?: string;
  atualizado_em?: string;
}
