export interface UsuarioLogAcesso {
  id_log: number;
  id_usuario: number;
  id_entidade: number;
  ip: string;
  user_agent: string;
  sucesso: number;
  criado_em: string;
}

export interface UsuarioLogAcessoCreate {
  ip?: string;
  user_agent?: string;
  sucesso?: number;
  criado_em?: string;
}

export interface UsuarioLogAcessoUpdate {
  ip?: string;
  user_agent?: string;
  sucesso?: number;
  criado_em?: string;
}
