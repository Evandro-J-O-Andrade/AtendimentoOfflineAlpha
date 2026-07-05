export interface RuntimeEstadoSobrevivencia {
  id_estado: number;
  runtime_device_id: string;
  modo_operacao: string;
  ultima_sincronizacao: string;
  hash_snapshot_runtime: string;
  evento_seguranca: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface RuntimeEstadoSobrevivenciaCreate {
  modo_operacao?: string;
  ultima_sincronizacao?: string;
  hash_snapshot_runtime?: string;
  evento_seguranca?: Record<string, unknown>;
  criado_em?: string;
}

export interface RuntimeEstadoSobrevivenciaUpdate {
  modo_operacao?: string;
  ultima_sincronizacao?: string;
  hash_snapshot_runtime?: string;
  evento_seguranca?: Record<string, unknown>;
  criado_em?: string;
}
