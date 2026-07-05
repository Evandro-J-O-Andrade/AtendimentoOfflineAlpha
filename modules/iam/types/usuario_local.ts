export interface UsuarioLocal {
  id_usuario_local: number;
  id_usuario: number;
  id_local: number;
  criado_em: string;
  id_entidade: number;
}

export interface UsuarioLocalCreate {
  criado_em?: string;
}

export interface UsuarioLocalUpdate {
  criado_em?: string;
}
