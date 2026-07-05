export interface Pessoa {
  id_pessoa: number;
  nome: string;
  nome_social: string;
  sexo: string;
  identidade_genero: string;
  data_nascimento: string;
  nacionalidade: string;
  naturalidade: string;
  nome_mae: string;
  nome_pai: string;
  estado_civil: string;
  tipo_pessoa: string;
  foto_url: string;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PessoaCreate {
  nome?: string;
  nome_social?: string;
  sexo?: string;
  data_nascimento?: string;
  nome_mae?: string;
  nome_pai?: string;
  estado_civil?: string;
  tipo_pessoa?: string;
  foto_url?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PessoaUpdate {
  nome?: string;
  nome_social?: string;
  sexo?: string;
  data_nascimento?: string;
  nome_mae?: string;
  nome_pai?: string;
  estado_civil?: string;
  tipo_pessoa?: string;
  foto_url?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
