export interface Agendamento {
  id_agendamento: number;
  id_sistema: number;
  id_unidade: number;
  id_local_operacional: number;
  id_profissional: number;
  id_paciente: number;
  id_ffa: number;
  id_senha: number;
  id_servico: number;
  inicio_em: string;
  fim_em: string;
  duracao_minutos: number;
  status: string;
  origem: string;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  criado_por: number;
  id_sessao_criacao: number;
  uuid_sync: string;
  versao_sync: number;
  hash_estado: string;
  id_entidade: number;
}

export interface AgendamentoCreate {
  inicio_em?: string;
  fim_em?: string;
  duracao_minutos?: number;
  status?: string;
  origem?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
  criado_por?: number;
  versao_sync?: number;
  hash_estado?: string;
}

export interface AgendamentoUpdate {
  inicio_em?: string;
  fim_em?: string;
  duracao_minutos?: number;
  status?: string;
  origem?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
  criado_por?: number;
  versao_sync?: number;
  hash_estado?: string;
}
