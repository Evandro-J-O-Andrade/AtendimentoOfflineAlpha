export interface PacienteCns {
  id_paciente_cns: number;
  id_paciente: number;
  cns: string;
  status: string;
  validado: number;
  origem: string;
  data_validacao: string;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PacienteCnsCreate {
  cns?: string;
  status?: string;
  origem?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PacienteCnsUpdate {
  cns?: string;
  status?: string;
  origem?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
