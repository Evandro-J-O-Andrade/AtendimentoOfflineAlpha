export interface AssistenciaSocialEvento {
  id_evento: number;
  id_as: number;
  id_sessao_usuario: number;
  tipo: string;
  detalhe: string;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface AssistenciaSocialEventoCreate {
  tipo?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface AssistenciaSocialEventoUpdate {
  tipo?: string;
  detalhe?: string;
  criado_em?: string;
}
