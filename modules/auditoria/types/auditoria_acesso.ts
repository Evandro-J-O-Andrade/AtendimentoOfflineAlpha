export interface AuditoriaAcesso {
  id_auditoria_acesso: number;
  id_sessao_usuario: number;
  id_usuario: number;
  recurso: string;
  acao: string;
  detalhe: string;
  ip: string;
  user_agent: string;
  criado_em: string;
  id_entidade: number;
}

export interface AuditoriaAcessoCreate {
  recurso?: string;
  acao?: string;
  detalhe?: string;
  ip?: string;
  user_agent?: string;
  criado_em?: string;
}

export interface AuditoriaAcessoUpdate {
  recurso?: string;
  acao?: string;
  detalhe?: string;
  ip?: string;
  user_agent?: string;
  criado_em?: string;
}
