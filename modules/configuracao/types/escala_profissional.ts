export interface EscalaProfissional {
  id_escala_profissional: number;
  id_funcionario: number;
  id_unidade: number;
  id_local: number;
  data_inicio: string;
  data_fim: string;
  tipo_escala: string;
  observacao: string;
  criado_em: string;
  id_entidade: number;
}

export interface EscalaProfissionalCreate {
  data_inicio?: string;
  data_fim?: string;
  tipo_escala?: string;
  observacao?: string;
  criado_em?: string;
}

export interface EscalaProfissionalUpdate {
  data_inicio?: string;
  data_fim?: string;
  tipo_escala?: string;
  observacao?: string;
  criado_em?: string;
}
