export interface SolicitacaoExame {
  id_solicitacao: number;
  id_atendimento: number;
  id_exame: number;
  id_sigpat: number;
  status: string;
  id_medico: number;
  solicitado_em: string;
  id_entidade: number;
}

export interface SolicitacaoExameCreate {
  status?: string;
  solicitado_em?: string;
}

export interface SolicitacaoExameUpdate {
  status?: string;
  solicitado_em?: string;
}
