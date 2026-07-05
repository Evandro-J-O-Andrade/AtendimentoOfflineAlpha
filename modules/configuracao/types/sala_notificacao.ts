export interface SalaNotificacao {
  id_notificacao: number;
  id_unidade: number;
  id_senha: number;
  id_ffa: number;
  tipo: string;
  status: string;
  detalhes: string;
  id_usuario_abertura: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface SalaNotificacaoCreate {
  tipo?: string;
  status?: string;
  detalhes?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface SalaNotificacaoUpdate {
  tipo?: string;
  status?: string;
  detalhes?: string;
  criado_em?: string;
  atualizado_em?: string;
}
