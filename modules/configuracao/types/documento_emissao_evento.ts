export interface DocumentoEmissaoEvento {
  id_evento: number;
  id_documento: number;
  tipo: string;
  detalhe: string;
  id_sessao_usuario: number;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface DocumentoEmissaoEventoCreate {
  tipo?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface DocumentoEmissaoEventoUpdate {
  tipo?: string;
  detalhe?: string;
  criado_em?: string;
}
