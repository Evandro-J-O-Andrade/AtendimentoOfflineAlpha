export interface KernelLedger {
  id_transacao: string;
  id_sessao: number;
  id_usuario: number;
  id_perfil: number;
  acao: string;
  contexto: string;
  payload: Record<string, unknown>;
  status: string;
  duracao_ms: number;
  mensagem: string;
  id_tenant: number;
  registrado_em: string;
  id_entidade: number;
}

export interface KernelLedgerCreate {
  acao?: string;
  contexto?: string;
  payload?: Record<string, unknown>;
  status?: string;
  duracao_ms?: number;
  mensagem?: string;
  registrado_em?: string;
}

export interface KernelLedgerUpdate {
  acao?: string;
  contexto?: string;
  payload?: Record<string, unknown>;
  status?: string;
  duracao_ms?: number;
  mensagem?: string;
  registrado_em?: string;
}
