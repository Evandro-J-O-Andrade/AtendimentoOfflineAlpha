export interface FarmacoAuditoria {
  id_auditoria: number;
  tabela: string;
  id_registro: number;
  acao: string;
  dados_antes: Record<string, unknown>;
  dados_depois: Record<string, unknown>;
  id_usuario: number;
  data_evento: string;
  id_entidade: number;
}

export interface FarmacoAuditoriaCreate {
  tabela?: string;
  acao?: string;
  dados_antes?: Record<string, unknown>;
  dados_depois?: Record<string, unknown>;
  data_evento?: string;
}

export interface FarmacoAuditoriaUpdate {
  tabela?: string;
  acao?: string;
  dados_antes?: Record<string, unknown>;
  dados_depois?: Record<string, unknown>;
  data_evento?: string;
}
