export interface UsuarioHistoricoSenha {
  id_historico: number;
  id_usuario: number;
  senha_hash: string;
  criado_em: string;
  id_entidade: number;
}

export interface UsuarioHistoricoSenhaCreate {
  senha_hash?: string;
  criado_em?: string;
}

export interface UsuarioHistoricoSenhaUpdate {
  senha_hash?: string;
  criado_em?: string;
}
