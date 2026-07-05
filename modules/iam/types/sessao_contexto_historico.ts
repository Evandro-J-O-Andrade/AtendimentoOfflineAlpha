export interface SessaoContextoHistorico {
  id: number;
  id_sessao_usuario: number;
  id_usuario: number;
  id_atendimento: number;
  id_entidade: number;
  id_unidade: number;
  id_local: number;
  contexto_anterior: Record<string, unknown>;
  contexto_novo: Record<string, unknown>;
  criado_em: string;
}

export interface SessaoContextoHistoricoCreate {
  contexto_anterior?: Record<string, unknown>;
  contexto_novo?: Record<string, unknown>;
  criado_em?: string;
}

export interface SessaoContextoHistoricoUpdate {
  contexto_anterior?: Record<string, unknown>;
  contexto_novo?: Record<string, unknown>;
  criado_em?: string;
}
