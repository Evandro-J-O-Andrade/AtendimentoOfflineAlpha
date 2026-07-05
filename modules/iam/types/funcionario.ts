export interface Funcionario {
  id_funcionario: number;
  id_pessoa: number;
  id_entidade: number;
  matricula: string;
  tipo_funcionario: string;
  cargo: string;
  departamento: string;
  data_admissao: string;
  data_demissao: string;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
}

export interface FuncionarioCreate {
  matricula?: string;
  tipo_funcionario?: string;
  cargo?: string;
  departamento?: string;
  data_admissao?: string;
  data_demissao?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface FuncionarioUpdate {
  matricula?: string;
  tipo_funcionario?: string;
  cargo?: string;
  departamento?: string;
  data_admissao?: string;
  data_demissao?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
