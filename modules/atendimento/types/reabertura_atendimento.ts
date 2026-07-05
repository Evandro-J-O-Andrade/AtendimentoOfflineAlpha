export interface ReaberturaAtendimento {
  id_reabertura: number;
  id_ffa: number;
  motivo: string;
  id_usuario: number;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface ReaberturaAtendimentoCreate {
  motivo?: string;
  criado_em?: string;
}

export interface ReaberturaAtendimentoUpdate {
  motivo?: string;
  criado_em?: string;
}
