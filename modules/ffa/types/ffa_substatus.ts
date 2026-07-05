export interface FfaSubstatus {
  id: number;
  id_ffa: number;
  categoria: string;
  status: string;
  ativo: number;
  criado_em: string;
  finalizado_em: string;
  id_usuario: number;
  observacao: string;
  id_entidade: number;
}

export interface FfaSubstatusCreate {
  categoria?: string;
  status?: string;
  ativo?: number;
  criado_em?: string;
  finalizado_em?: string;
  observacao?: string;
}

export interface FfaSubstatusUpdate {
  categoria?: string;
  status?: string;
  ativo?: number;
  criado_em?: string;
  finalizado_em?: string;
  observacao?: string;
}
