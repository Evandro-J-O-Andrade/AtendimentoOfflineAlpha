export interface UsuarioSenhaHistorico {
  id_usuario_senha_hist: number;
  id_usuario: number;
  hash_formato: string;
  motivo: string;
  detalhe: string;
  criado_em: string;
  id_sessao_usuario: number;
  id_usuario_executor: number;
  id_entidade: number;
}

export interface UsuarioSenhaHistoricoCreate {
  hash_formato?: string;
  motivo?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface UsuarioSenhaHistoricoUpdate {
  hash_formato?: string;
  motivo?: string;
  detalhe?: string;
  criado_em?: string;
}
