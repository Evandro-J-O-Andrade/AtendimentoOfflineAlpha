export interface AuthGrupoUsuario {
  id_grupo_usuario: number;
  id_grupo: number;
  id_usuario: number;
  papel: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface AuthGrupoUsuarioCreate {
  papel?: string;
  ativo?: number;
  criado_em?: string;
}

export interface AuthGrupoUsuarioUpdate {
  papel?: string;
  ativo?: number;
  criado_em?: string;
}
