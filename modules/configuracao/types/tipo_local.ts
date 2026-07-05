export interface TipoLocal {
  id_tipo_local: number;
  codigo: string;
  nome: string;
  categoria: string;
  descricao: string;
  criado_em: string;
  categoria_operacional: string;
  descricao_operacional: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface TipoLocalCreate {
  codigo?: string;
  nome?: string;
  categoria?: string;
  descricao?: string;
  criado_em?: string;
  categoria_operacional?: string;
  descricao_operacional?: string;
  atualizado_em?: string;
}

export interface TipoLocalUpdate {
  codigo?: string;
  nome?: string;
  categoria?: string;
  descricao?: string;
  criado_em?: string;
  categoria_operacional?: string;
  descricao_operacional?: string;
  atualizado_em?: string;
}
