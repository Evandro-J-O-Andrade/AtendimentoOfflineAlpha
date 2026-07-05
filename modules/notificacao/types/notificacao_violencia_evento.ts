export interface NotificacaoViolenciaEvento {
  id_evento: number;
  id_notificacao: number;
  tipo_evento: string;
  status_anterior: string;
  status_novo: string;
  detalhes: string;
  id_sessao_usuario: number;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface NotificacaoViolenciaEventoCreate {
  tipo_evento?: string;
  status_anterior?: string;
  status_novo?: string;
  detalhes?: string;
  criado_em?: string;
}

export interface NotificacaoViolenciaEventoUpdate {
  tipo_evento?: string;
  status_anterior?: string;
  status_novo?: string;
  detalhes?: string;
  criado_em?: string;
}
