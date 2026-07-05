export interface AuditoriaMestre {
  id: number;
  id_sessao_usuario: number;
  dominio: string;
  acao: string;
  tabela_afetada: string;
  id_registro: number;
  valor_anterior: Record<string, unknown>;
  valor_novo: Record<string, unknown>;
  motivo_alteracao: string;
  data_evento: string;
  id_entidade: number;
}

export interface AuditoriaMestreCreate {
  dominio?: string;
  acao?: string;
  tabela_afetada?: string;
  valor_anterior?: Record<string, unknown>;
  valor_novo?: Record<string, unknown>;
  motivo_alteracao?: string;
  data_evento?: string;
}

export interface AuditoriaMestreUpdate {
  dominio?: string;
  acao?: string;
  tabela_afetada?: string;
  valor_anterior?: Record<string, unknown>;
  valor_novo?: Record<string, unknown>;
  motivo_alteracao?: string;
  data_evento?: string;
}
