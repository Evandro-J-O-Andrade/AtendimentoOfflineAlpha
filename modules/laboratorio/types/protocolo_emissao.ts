export interface ProtocoloEmissao {
  id_emissao: number;
  tipo: string;
  chave: string;
  codigo: string;
  ano: number;
  data_ref: string;
  id_sessao_usuario: number;
  id_usuario: number;
  id_paciente: number;
  id_ffa: number;
  id_senha: number;
  id_cliente: number;
  criado_em: string;
  id_entidade: number;
}

export interface ProtocoloEmissaoCreate {
  tipo?: string;
  chave?: string;
  codigo?: string;
  ano?: number;
  data_ref?: string;
  criado_em?: string;
}

export interface ProtocoloEmissaoUpdate {
  tipo?: string;
  chave?: string;
  codigo?: string;
  ano?: number;
  data_ref?: string;
  criado_em?: string;
}
