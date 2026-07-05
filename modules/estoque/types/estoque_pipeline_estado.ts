export interface EstoquePipelineEstado {
  hash_execucao: string;
  etapa_atual: string;
  lease_expira_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface EstoquePipelineEstadoCreate {
  hash_execucao?: string;
  etapa_atual?: string;
  lease_expira_em?: string;
  atualizado_em?: string;
}

export interface EstoquePipelineEstadoUpdate {
  hash_execucao?: string;
  etapa_atual?: string;
  lease_expira_em?: string;
  atualizado_em?: string;
}
