export interface RuntimeExecutionQueue {
  id: string;
  id_sessao: number;
  id_usuario: number;
  id_perfil: number;
  acao: string;
  contexto: string;
  payload: Record<string, unknown>;
  status: string;
  prioridade: number;
  retry_count: number;
  ultimo_erro: string;
  duracao_ms: number;
  resultado: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface RuntimeExecutionQueueCreate {
  acao?: string;
  contexto?: string;
  payload?: Record<string, unknown>;
  status?: string;
  retry_count?: number;
  ultimo_erro?: string;
  duracao_ms?: number;
  resultado?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface RuntimeExecutionQueueUpdate {
  acao?: string;
  contexto?: string;
  payload?: Record<string, unknown>;
  status?: string;
  retry_count?: number;
  ultimo_erro?: string;
  duracao_ms?: number;
  resultado?: string;
  criado_em?: string;
  atualizado_em?: string;
}
