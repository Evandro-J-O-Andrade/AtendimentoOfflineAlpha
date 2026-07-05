export interface NotificacaoEpidemiologicaEvento {
  id_evento: number;
  id_notificacao: number;
  id_sessao_usuario: number;
  tipo: string;
  detalhe: string;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface NotificacaoEpidemiologicaEventoCreate {
  tipo?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface NotificacaoEpidemiologicaEventoUpdate {
  tipo?: string;
  detalhe?: string;
  criado_em?: string;
}
