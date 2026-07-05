export interface InternacaoHistorico {
  id: number;
  id_internacao: number;
  evento: string;
  descricao: string;
  id_usuario: number;
  criado_em: string;
  id_sessao_usuario: number;
  id_local_operacional: number;
  id_entidade: number;
}

export interface InternacaoHistoricoCreate {
  evento?: string;
  descricao?: string;
  criado_em?: string;
}

export interface InternacaoHistoricoUpdate {
  evento?: string;
  descricao?: string;
  criado_em?: string;
}
