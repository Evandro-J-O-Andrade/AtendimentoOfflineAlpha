export interface AtendimentoProfissional {
  id: number;
  id_atendimento: number;
  id_usuario: number;
  papel: string;
  criado_em: string;
  id_entidade: number;
}

export interface AtendimentoProfissionalCreate {
  papel?: string;
  criado_em?: string;
}

export interface AtendimentoProfissionalUpdate {
  papel?: string;
  criado_em?: string;
}
