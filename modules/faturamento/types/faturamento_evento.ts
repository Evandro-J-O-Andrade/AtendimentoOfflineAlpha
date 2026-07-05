export interface FaturamentoEvento {
  id_evento: number;
  id_conta: number;
  evento: string;
  id_usuario: number;
  observacao: string;
  criado_em: string;
  id_sessao_usuario: number;
  tipo: string;
  detalhe: string;
  id_entidade: number;
}

export interface FaturamentoEventoCreate {
  evento?: string;
  observacao?: string;
  criado_em?: string;
  tipo?: string;
  detalhe?: string;
}

export interface FaturamentoEventoUpdate {
  evento?: string;
  observacao?: string;
  criado_em?: string;
  tipo?: string;
  detalhe?: string;
}
