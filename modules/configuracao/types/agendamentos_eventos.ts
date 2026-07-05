export interface AgendamentosEventos {
  id_evento: number;
  id_agendamento: number;
  tipo: string;
  detalhe: string;
  de_status: string;
  para_status: string;
  criado_em: string;
  id_usuario: number;
  id_sessao_usuario: number;
  id_entidade: number;
}

export interface AgendamentosEventosCreate {
  tipo?: string;
  detalhe?: string;
  de_status?: string;
  para_status?: string;
  criado_em?: string;
}

export interface AgendamentosEventosUpdate {
  tipo?: string;
  detalhe?: string;
  de_status?: string;
  para_status?: string;
  criado_em?: string;
}
