export interface GasoSolicitacao {
  id_gaso: number;
  id_unidade: number;
  id_senha: number;
  id_ffa: number;
  tipo: string;
  status: string;
  local_destino: string;
  observacao: string;
  id_usuario_abertura: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface GasoSolicitacaoCreate {
  tipo?: string;
  status?: string;
  local_destino?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface GasoSolicitacaoUpdate {
  tipo?: string;
  status?: string;
  local_destino?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
