export interface Especialidade {
  id_especialidade: number;
  nome: string;
  cbo: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface EspecialidadeCreate {
  nome?: string;
  cbo?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface EspecialidadeUpdate {
  nome?: string;
  cbo?: string;
  criado_em?: string;
  atualizado_em?: string;
}
