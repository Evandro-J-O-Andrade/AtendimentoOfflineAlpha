export interface FuncionarioUnidade {
  id_funcionario_unidade: number;
  id_funcionario: number;
  id_unidade: number;
  funcao_unidade: string;
  data_inicio: string;
  data_fim: string;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface FuncionarioUnidadeCreate {
  data_inicio?: string;
  data_fim?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface FuncionarioUnidadeUpdate {
  data_inicio?: string;
  data_fim?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
