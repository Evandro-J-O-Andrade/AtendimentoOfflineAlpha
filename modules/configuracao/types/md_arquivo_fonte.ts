export interface MdArquivoFonte {
  id_md_arquivo_fonte: number;
  tipo: string;
  competencia: string;
  origem: string;
  descricao: string;
  url_origem: string;
  nome_arquivo: string;
  tamanho_bytes: number;
  sha256: string;
  baixado_em: string;
  processado_em: string;
  status: string;
  mensagem_erro: string;
  criado_em: string;
  id_entidade: number;
}

export interface MdArquivoFonteCreate {
  tipo?: string;
  competencia?: string;
  origem?: string;
  descricao?: string;
  url_origem?: string;
  nome_arquivo?: string;
  tamanho_bytes?: number;
  sha256?: string;
  baixado_em?: string;
  processado_em?: string;
  status?: string;
  mensagem_erro?: string;
  criado_em?: string;
}

export interface MdArquivoFonteUpdate {
  tipo?: string;
  competencia?: string;
  origem?: string;
  descricao?: string;
  url_origem?: string;
  nome_arquivo?: string;
  tamanho_bytes?: number;
  sha256?: string;
  baixado_em?: string;
  processado_em?: string;
  status?: string;
  mensagem_erro?: string;
  criado_em?: string;
}
