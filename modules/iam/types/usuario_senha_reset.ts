export interface UsuarioSenhaReset {
  id_usuario_senha_reset: number;
  id_usuario: number;
  token_hash: string;
  expira_em: string;
  usado_em: string;
  id_sessao_usuario_solicitante: number;
  id_usuario_solicitante: number;
  criado_em: string;
  id_entidade: number;
}

export interface UsuarioSenhaResetCreate {
  token_hash?: string;
  expira_em?: string;
  usado_em?: string;
  criado_em?: string;
}

export interface UsuarioSenhaResetUpdate {
  token_hash?: string;
  expira_em?: string;
  usado_em?: string;
  criado_em?: string;
}
