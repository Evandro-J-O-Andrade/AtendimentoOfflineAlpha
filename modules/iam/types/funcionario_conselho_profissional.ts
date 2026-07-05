export interface FuncionarioConselhoProfissional {
  id_funcionario_conselho: number;
  id_funcionario: number;
  conselho: string;
  numero_registro: string;
  uf: string;
  situacao: string;
  criado_em: string;
  id_entidade: number;
}

export interface FuncionarioConselhoProfissionalCreate {
  conselho?: string;
  numero_registro?: string;
  uf?: string;
  situacao?: string;
  criado_em?: string;
}

export interface FuncionarioConselhoProfissionalUpdate {
  conselho?: string;
  numero_registro?: string;
  uf?: string;
  situacao?: string;
  criado_em?: string;
}
