export interface LogAuditoria {
  id_log: number;
  id_usuario: number;
  acao: string;
  tabela_afetada: string;
  id_registro: number;
  antes: string;
  depois: string;
  justificativa: string;
  data_hora: string;
  id_entidade: number;
}

export interface LogAuditoriaCreate {
  acao?: string;
  tabela_afetada?: string;
  antes?: string;
  depois?: string;
  justificativa?: string;
  data_hora?: string;
}

export interface LogAuditoriaUpdate {
  acao?: string;
  tabela_afetada?: string;
  antes?: string;
  depois?: string;
  justificativa?: string;
  data_hora?: string;
}
