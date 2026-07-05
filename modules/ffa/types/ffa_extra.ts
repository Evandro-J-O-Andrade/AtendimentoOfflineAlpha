export interface FfaExtra {
  id: number;
  id_atendimento: number;
  tipo_extra: string;
  descricao: string;
  status: string;
  criado_em: string;
  id_entidade: number;
}

export interface FfaExtraCreate {
  tipo_extra?: string;
  descricao?: string;
  status?: string;
  criado_em?: string;
}

export interface FfaExtraUpdate {
  tipo_extra?: string;
  descricao?: string;
  status?: string;
  criado_em?: string;
}
