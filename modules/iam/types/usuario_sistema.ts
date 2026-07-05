export interface UsuarioSistema {
  id_usuario_sistema: number;
  id_usuario: number;
  id_sistema: number;
  id_perfil: number;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface UsuarioSistemaCreate {
  ativo?: number;
  criado_em?: string;
}

export interface UsuarioSistemaUpdate {
  ativo?: number;
  criado_em?: string;
}
