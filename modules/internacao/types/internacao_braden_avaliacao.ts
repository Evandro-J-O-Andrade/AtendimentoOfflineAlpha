export interface InternacaoBradenAvaliacao {
  id_internacao_braden_avaliacao: number;
  id_internacao: number;
  data_hora: string;
  risco: string;
  observacoes: string;
  id_documento: number;
  id_usuario_responsavel: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface InternacaoBradenAvaliacaoCreate {
  data_hora?: string;
  risco?: string;
  observacoes?: string;
  criado_em?: string;
}

export interface InternacaoBradenAvaliacaoUpdate {
  data_hora?: string;
  risco?: string;
  observacoes?: string;
  criado_em?: string;
}
