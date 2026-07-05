export interface PainelGrupo {
  id_grupo: number;
  codigo: string;
  nome: string;
  descricao: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface PainelGrupoCreate {
  codigo?: string;
  nome?: string;
  descricao?: string;
  ativo?: number;
  criado_em?: string;
}

export interface PainelGrupoUpdate {
  codigo?: string;
  nome?: string;
  descricao?: string;
  ativo?: number;
  criado_em?: string;
}
