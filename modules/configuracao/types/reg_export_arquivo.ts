export interface RegExportArquivo {
  id_export_arquivo: number;
  id_export_lote: number;
  formato: string;
  mime_type: string;
  nome_arquivo: string;
  tamanho_bytes: number;
  sha256: string;
  storage_uri: string;
  criado_em: string;
  id_entidade: number;
}

export interface RegExportArquivoCreate {
  formato?: string;
  mime_type?: string;
  nome_arquivo?: string;
  tamanho_bytes?: number;
  sha256?: string;
  storage_uri?: string;
  criado_em?: string;
}

export interface RegExportArquivoUpdate {
  formato?: string;
  mime_type?: string;
  nome_arquivo?: string;
  tamanho_bytes?: number;
  sha256?: string;
  storage_uri?: string;
  criado_em?: string;
}
