export interface PerfilPermissao {
  id_perfil: number;
  id_permissao: number;
  criado_em: string;
  id_entidade: number;
}

export interface PerfilPermissaoCreate {
  criado_em?: string;
}

export interface PerfilPermissaoUpdate {
  criado_em?: string;
}
