export interface AtendimentoPedidosExame {
  id: number;
  id_atendimento: number;
  id_medico_solicitante: number;
  id_exame_tuss: string;
  status_exame: string;
  prioridade: string;
  data_solicitacao: string;
  url_laudo_pacs: string;
  id_entidade: number;
}

export interface AtendimentoPedidosExameCreate {
  status_exame?: string;
  data_solicitacao?: string;
  url_laudo_pacs?: string;
}

export interface AtendimentoPedidosExameUpdate {
  status_exame?: string;
  data_solicitacao?: string;
  url_laudo_pacs?: string;
}
