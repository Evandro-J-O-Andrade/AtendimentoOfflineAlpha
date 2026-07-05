export interface ManutencaoExecucao {
  id_execucao: number;
  id_chamado: number;
  tecnico: number;
  descricao_servico: string;
  inicio_em: string;
  fim_em: string;
  status: string;
  id_entidade: number;
}

export interface ManutencaoExecucaoCreate {
  tecnico?: number;
  descricao_servico?: string;
  inicio_em?: string;
  fim_em?: string;
  status?: string;
}

export interface ManutencaoExecucaoUpdate {
  tecnico?: number;
  descricao_servico?: string;
  inicio_em?: string;
  fim_em?: string;
  status?: string;
}
