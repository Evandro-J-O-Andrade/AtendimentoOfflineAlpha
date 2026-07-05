export interface Obito {
  id_obito: number;
  id_ffa: number;
  id_sessao_usuario: number;
  id_local_operacional: number;
  data_hora_obito: string;
  id_usuario_responsavel: number;
  evolucao_inicial: string;
  evolucao_final: string;
  observacao: string;
  status: string;
  criado_em: string;
  atualizado_em: string;
  cancelado_em: string;
  cancelado_por: number;
  id_entidade: number;
}

export interface ObitoCreate {
  data_hora_obito?: string;
  evolucao_inicial?: string;
  evolucao_final?: string;
  observacao?: string;
  status?: string;
  criado_em?: string;
  atualizado_em?: string;
  cancelado_em?: string;
  cancelado_por?: number;
}

export interface ObitoUpdate {
  data_hora_obito?: string;
  evolucao_inicial?: string;
  evolucao_final?: string;
  observacao?: string;
  status?: string;
  criado_em?: string;
  atualizado_em?: string;
  cancelado_em?: string;
  cancelado_por?: number;
}
