export interface Local {
  id_local: number;
  id_unidade: number;
  id_tipo_local: number;
  codigo: string;
  nome: string;
  descricao: string;
  andar: string;
  bloco: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface LocalCreate {
  codigo?: string;
  nome?: string;
  descricao?: string;
  andar?: string;
  bloco?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface LocalUpdate {
  codigo?: string;
  nome?: string;
  descricao?: string;
  andar?: string;
  bloco?: string;
  criado_em?: string;
  atualizado_em?: string;
}
