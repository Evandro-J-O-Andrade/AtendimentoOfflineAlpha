export interface DocumentoEmissao {
  id_documento: number;
  id_ffa: number;
  id_paciente: number;
  id_senha: number;
  gpat: string;
  tipo_documento: string;
  entidade_ref: string;
  id_ref: number;
  numero_documento: string;
  hash_documento: string;
  status: string;
  id_sessao_usuario: number;
  id_usuario: number;
  id_unidade: number;
  id_local_operacional: number;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface DocumentoEmissaoCreate {
  gpat?: string;
  tipo_documento?: string;
  numero_documento?: string;
  hash_documento?: string;
  status?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface DocumentoEmissaoUpdate {
  gpat?: string;
  tipo_documento?: string;
  numero_documento?: string;
  hash_documento?: string;
  status?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
