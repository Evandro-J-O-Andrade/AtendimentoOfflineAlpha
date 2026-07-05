export interface MdArquivoFonteEvento {
  id_md_arquivo_fonte_evento: number;
  id_md_arquivo_fonte: number;
  ocorrido_em: string;
  acao: string;
  detalhes: string;
  id_sessao_usuario: number;
  id_usuario: number;
  id_entidade: number;
}

export interface MdArquivoFonteEventoCreate {
  acao?: string;
  detalhes?: string;
}

export interface MdArquivoFonteEventoUpdate {
  acao?: string;
  detalhes?: string;
}
