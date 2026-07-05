export interface FuncionarioEspecialidade {
  id_funcionario_especialidade: number;
  id_funcionario: number;
  especialidade: string;
  principal: number;
  criado_em: string;
  id_entidade: number;
}

export interface FuncionarioEspecialidadeCreate {
  principal?: number;
  criado_em?: string;
}

export interface FuncionarioEspecialidadeUpdate {
  principal?: number;
  criado_em?: string;
}
