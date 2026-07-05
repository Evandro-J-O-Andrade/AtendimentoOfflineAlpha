export interface RegAnexo {
  id_anexo: number;
  entidade_ref: string;
  id_ref: number;
  categoria: string;
  nome_arquivo: string;
  mime_type: string;
  tamanho_bytes: number;
  sha256: string;
  storage_uri: string;
  id_sessao_usuario: number;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface RegAnexoCreate {
  categoria?: string;
  nome_arquivo?: string;
  mime_type?: string;
  tamanho_bytes?: number;
  sha256?: string;
  storage_uri?: string;
  criado_em?: string;
}

export interface RegAnexoUpdate {
  categoria?: string;
  nome_arquivo?: string;
  mime_type?: string;
  tamanho_bytes?: number;
  sha256?: string;
  storage_uri?: string;
  criado_em?: string;
}
