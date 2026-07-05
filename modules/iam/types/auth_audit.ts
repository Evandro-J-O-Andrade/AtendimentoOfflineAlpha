export interface AuthAudit {
  id_audit: number;
  id_usuario: number;
  id_sessao: number;
  acao: string;
  recurso: string;
  detalhes: Record<string, unknown>;
  ip_origem: string;
  user_agent: string;
  sucesso: number;
  criado_em: string;
  id_entidade: number;
}

export interface AuthAuditCreate {
  acao?: string;
  recurso?: string;
  detalhes?: Record<string, unknown>;
  ip_origem?: string;
  user_agent?: string;
  sucesso?: number;
  criado_em?: string;
}

export interface AuthAuditUpdate {
  acao?: string;
  recurso?: string;
  detalhes?: Record<string, unknown>;
  ip_origem?: string;
  user_agent?: string;
  sucesso?: number;
  criado_em?: string;
}
