export interface AuthGrupo {
  id_grupo: number;
  nome: string;
  descricao: string;
  tipo_grupo: string;
  id_unidade: number;
  ativo: number;
  criado_por: number;
  criado_em: string;
  id_entidade: number;
}

export interface AuthGrupoCreate {
  nome?: string;
  descricao?: string;
  tipo_grupo?: string;
  ativo?: number;
  criado_por?: number;
  criado_em?: string;
}

export interface AuthGrupoUpdate {
  nome?: string;
  descricao?: string;
  tipo_grupo?: string;
  ativo?: number;
  criado_por?: number;
  criado_em?: string;
}
