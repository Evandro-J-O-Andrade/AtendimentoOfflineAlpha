export interface RegExportLote {
  id_export_lote: number;
  tipo: string;
  competencia: string;
  id_sessao_usuario: number;
  id_usuario_criador: number;
  id_unidade: number;
  id_local_operacional: number;
  status: string;
  protocolo_externo: string;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface RegExportLoteCreate {
  tipo?: string;
  competencia?: string;
  status?: string;
  protocolo_externo?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface RegExportLoteUpdate {
  tipo?: string;
  competencia?: string;
  status?: string;
  protocolo_externo?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
