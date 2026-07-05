export interface DocumentoArquivo {
  id_documento: number;
  formato: string;
  mime_type: string;
  nome_arquivo: string;
  tamanho_bytes: number;
  sha256: string;
  storage_uri: string;
  criado_em: string;
  id_entidade: number;
}

export interface DocumentoArquivoCreate {
  formato?: string;
  mime_type?: string;
  nome_arquivo?: string;
  tamanho_bytes?: number;
  sha256?: string;
  storage_uri?: string;
  criado_em?: string;
}

export interface DocumentoArquivoUpdate {
  formato?: string;
  mime_type?: string;
  nome_arquivo?: string;
  tamanho_bytes?: number;
  sha256?: string;
  storage_uri?: string;
  criado_em?: string;
}
