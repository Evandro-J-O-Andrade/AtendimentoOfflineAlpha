export interface FfaDemandasExternas {
  id: number;
  id_atendimento: number;
  tipo_demanda: string;
  descricao: string;
  profissional_externo: string;
  status: string;
  criado_em: string;
  id_entidade: number;
}

export interface FfaDemandasExternasCreate {
  tipo_demanda?: string;
  descricao?: string;
  profissional_externo?: string;
  status?: string;
  criado_em?: string;
}

export interface FfaDemandasExternasUpdate {
  tipo_demanda?: string;
  descricao?: string;
  profissional_externo?: string;
  status?: string;
  criado_em?: string;
}
