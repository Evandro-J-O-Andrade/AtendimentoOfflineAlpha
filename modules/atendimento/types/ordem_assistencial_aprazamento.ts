export interface OrdemAssistencialAprazamento {
  id_aprazamento: number;
  id_item: number;
  previsto_em: string;
  status: string;
  executado_em: string;
  id_usuario_execucao: number;
  id_sessao_usuario_execucao: number;
  id_local_operacional_execucao: number;
  observacao: string;
  criado_em: string;
  criado_por: number;
  id_sessao_usuario_criado: number;
  id_atendimento: number;
  id_entidade: number;
}

export interface OrdemAssistencialAprazamentoCreate {
  previsto_em?: string;
  status?: string;
  executado_em?: string;
  observacao?: string;
  criado_em?: string;
  criado_por?: number;
}

export interface OrdemAssistencialAprazamentoUpdate {
  previsto_em?: string;
  status?: string;
  executado_em?: string;
  observacao?: string;
  criado_em?: string;
  criado_por?: number;
}
