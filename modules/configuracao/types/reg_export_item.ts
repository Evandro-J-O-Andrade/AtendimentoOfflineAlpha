export interface RegExportItem {
  id_export_item: number;
  id_export_lote: number;
  entidade_ref: string;
  id_ref: number;
  status: string;
  payload_hash: string;
  protocolo_externo: string;
  tentativas: number;
  ultima_tentativa_em: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface RegExportItemCreate {
  status?: string;
  payload_hash?: string;
  protocolo_externo?: string;
  tentativas?: number;
  ultima_tentativa_em?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface RegExportItemUpdate {
  status?: string;
  payload_hash?: string;
  protocolo_externo?: string;
  tentativas?: number;
  ultima_tentativa_em?: string;
  criado_em?: string;
  atualizado_em?: string;
}
