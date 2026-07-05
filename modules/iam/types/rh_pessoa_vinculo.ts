export interface RhPessoaVinculo {
  id_rh_vinculo: number;
  id_pessoa: number;
  tipo_vinculo: string;
  matricula: string;
  cpf: string;
  rg: string;
  orgao_emissor: string;
  pis_pasep: string;
  data_admissao: string;
  data_demissao: string;
  status: string;
  id_unidade_lotacao: number;
  id_local_lotacao: number;
  cargo: string;
  setor: string;
  email: string;
  telefone: string;
  endereco: string;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface RhPessoaVinculoCreate {
  tipo_vinculo?: string;
  matricula?: string;
  cpf?: string;
  rg?: string;
  orgao_emissor?: string;
  pis_pasep?: string;
  data_admissao?: string;
  data_demissao?: string;
  status?: string;
  cargo?: string;
  setor?: string;
  email?: string;
  telefone?: string;
  endereco?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface RhPessoaVinculoUpdate {
  tipo_vinculo?: string;
  matricula?: string;
  cpf?: string;
  rg?: string;
  orgao_emissor?: string;
  pis_pasep?: string;
  data_admissao?: string;
  data_demissao?: string;
  status?: string;
  cargo?: string;
  setor?: string;
  email?: string;
  telefone?: string;
  endereco?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
