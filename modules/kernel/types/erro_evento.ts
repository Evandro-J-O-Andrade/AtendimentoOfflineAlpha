export interface ErroEvento {
  id_erro: number;
  id_sessao_usuario: number;
  id_erro_catalogo: number;
  uuid_transacao: string;
  dominio: string;
  acao: string;
  mensagem_erro: string;
  stack_trace: Record<string, unknown>;
  payload_tentativa: Record<string, unknown>;
  criado_em: string;
  id_entidade: number;
}

export interface ErroEventoCreate {
  dominio?: string;
  acao?: string;
  mensagem_erro?: string;
  stack_trace?: Record<string, unknown>;
  payload_tentativa?: Record<string, unknown>;
  criado_em?: string;
}

export interface ErroEventoUpdate {
  dominio?: string;
  acao?: string;
  mensagem_erro?: string;
  stack_trace?: Record<string, unknown>;
  payload_tentativa?: Record<string, unknown>;
  criado_em?: string;
}
