export interface Usuario {
  id_usuario: number;
  id_pessoa: number;
  id_entidade: number;
  login: string;
  senha_hash: string;
  tentativas_login: number;
  bloqueado_ate: string;
  ultimo_login: string;
  ultimo_ip: string;
  criado_em: string;
  atualizado_em: string;
}

export interface UsuarioCreate {
  login?: string;
  senha_hash?: string;
  tentativas_login?: number;
  bloqueado_ate?: string;
  ultimo_login?: string;
  ultimo_ip?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface UsuarioUpdate {
  login?: string;
  senha_hash?: string;
  tentativas_login?: number;
  bloqueado_ate?: string;
  ultimo_login?: string;
  ultimo_ip?: string;
  criado_em?: string;
  atualizado_em?: string;
}
