export interface PessoaDocumento {
  id_pessoa_documento: number;
  id_pessoa: number;
  tipo_documento: string;
  numero: string;
  orgao_emissor: string;
  uf_emissor: string;
  data_emissao: string;
  data_validade: string;
  principal: number;
  observacao: string;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PessoaDocumentoCreate {
  tipo_documento?: string;
  numero?: string;
  orgao_emissor?: string;
  uf_emissor?: string;
  data_emissao?: string;
  principal?: number;
  observacao?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PessoaDocumentoUpdate {
  tipo_documento?: string;
  numero?: string;
  orgao_emissor?: string;
  uf_emissor?: string;
  data_emissao?: string;
  principal?: number;
  observacao?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
