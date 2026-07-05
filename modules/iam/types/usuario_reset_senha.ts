export interface UsuarioResetSenha {
  id_reset: number;
  id_usuario: number;
  token_hash: string;
  criado_em: string;
  expira_em: string;
  usado_em: string;
  ip_solicitacao: string;
  user_agent: string;
  id_entidade: number;
}

export interface UsuarioResetSenhaCreate {
  token_hash?: string;
  criado_em?: string;
  expira_em?: string;
  usado_em?: string;
  ip_solicitacao?: string;
  user_agent?: string;
}

export interface UsuarioResetSenhaUpdate {
  token_hash?: string;
  criado_em?: string;
  expira_em?: string;
  usado_em?: string;
  ip_solicitacao?: string;
  user_agent?: string;
}
