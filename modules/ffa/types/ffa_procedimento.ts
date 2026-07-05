export interface FfaProcedimento {
  id_procedimento: number;
  id_ffa: number;
  tipo: string;
  status: string;
  prioridade: string;
  id_usuario_solicitante: number;
  id_usuario_execucao: number;
  criado_em: string;
  iniciado_em: string;
  finalizado_em: string;
  observacao: string;
  id_entidade: number;
}

export interface FfaProcedimentoCreate {
  tipo?: string;
  status?: string;
  criado_em?: string;
  iniciado_em?: string;
  finalizado_em?: string;
  observacao?: string;
}

export interface FfaProcedimentoUpdate {
  tipo?: string;
  status?: string;
  criado_em?: string;
  iniciado_em?: string;
  finalizado_em?: string;
  observacao?: string;
}
