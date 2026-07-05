export interface Atendimento {
  id_atendimento: number;
  id_saas_entidade: number;
  id_unidade: number;
  id_ffa: number;
  id_profissional_responsavel: number;
  tipo_atendimento: string;
  modo_entrada: string;
  status_execucao: string;
  id_faturamento_guia: string;
  id_sessao_usuario_criacao: number;
  id_sessao_usuario_alteracao: number;
  uuid_sync: string;
  versao_sync: number;
  hash_estado: string;
  criado_em: string;
  atualizado_em: string;
  finalizado_em: string;
  removido_em: string;
  id_entidade: number;
}

export interface AtendimentoCreate {
  tipo_atendimento?: string;
  modo_entrada?: string;
  status_execucao?: string;
  versao_sync?: number;
  hash_estado?: string;
  criado_em?: string;
  atualizado_em?: string;
  finalizado_em?: string;
}

export interface AtendimentoUpdate {
  tipo_atendimento?: string;
  modo_entrada?: string;
  status_execucao?: string;
  versao_sync?: number;
  hash_estado?: string;
  criado_em?: string;
  atualizado_em?: string;
  finalizado_em?: string;
}
