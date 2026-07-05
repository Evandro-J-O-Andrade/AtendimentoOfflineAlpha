export interface MedicacaoReavaliacao {
  id_reavaliacao: number;
  id_fila_medicacao: number;
  id_ffa: number;
  previsto_em: string;
  executado_em: string;
  status: string;
  id_sessao_usuario: number;
  id_local_operacional: number;
  id_usuario_criador: number;
  id_usuario_executor: number;
  observacao: string;
  criado_em: string;
  id_entidade: number;
}

export interface MedicacaoReavaliacaoCreate {
  previsto_em?: string;
  executado_em?: string;
  status?: string;
  observacao?: string;
  criado_em?: string;
}

export interface MedicacaoReavaliacaoUpdate {
  previsto_em?: string;
  executado_em?: string;
  status?: string;
  observacao?: string;
  criado_em?: string;
}
