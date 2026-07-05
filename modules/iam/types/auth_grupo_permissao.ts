export interface AuthGrupoPermissao {
  id_grupo_permissao: number;
  id_grupo: number;
  recurso: string;
  acao: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface AuthGrupoPermissaoCreate {
  recurso?: string;
  acao?: string;
  ativo?: number;
  criado_em?: string;
}

export interface AuthGrupoPermissaoUpdate {
  recurso?: string;
  acao?: string;
  ativo?: number;
  criado_em?: string;
}
