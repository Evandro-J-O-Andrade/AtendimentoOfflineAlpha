export interface RuntimeSnapshotGovernanca {
  id_governanca: number;
  dominio_fluxo: string;
  ttl_snapshot_horas: number;
  tolerancia_execucao_horas: number;
  exigir_revalidacao_expirada: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface RuntimeSnapshotGovernancaCreate {
  dominio_fluxo?: string;
  ttl_snapshot_horas?: number;
  tolerancia_execucao_horas?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface RuntimeSnapshotGovernancaUpdate {
  dominio_fluxo?: string;
  ttl_snapshot_horas?: number;
  tolerancia_execucao_horas?: number;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
