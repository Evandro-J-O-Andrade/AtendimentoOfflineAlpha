export interface UsuarioPerfil {
  id_usuario: number;
  id_entidade: number;
  id_perfil: number;
  criado_em: string;
}

export interface UsuarioPerfilCreate {
  criado_em?: string;
}

export interface UsuarioPerfilUpdate {
  criado_em?: string;
}
