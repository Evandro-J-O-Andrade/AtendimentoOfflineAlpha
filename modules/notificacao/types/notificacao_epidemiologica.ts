export interface NotificacaoEpidemiologica {
  id: number;
  id_atendimento: number;
  cid_10: string;
  doenca_suspeita: string;
  status_notificacao: string;
  data_evento: string;
  id_sessao_usuario: number;
  id_usuario_criador: number;
  observacao: string;
  protocolo_ms: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface NotificacaoEpidemiologicaCreate {
  doenca_suspeita?: string;
  status_notificacao?: string;
  data_evento?: string;
  observacao?: string;
  protocolo_ms?: string;
  atualizado_em?: string;
}

export interface NotificacaoEpidemiologicaUpdate {
  doenca_suspeita?: string;
  status_notificacao?: string;
  data_evento?: string;
  observacao?: string;
  protocolo_ms?: string;
  atualizado_em?: string;
}
