export interface AuditoriaContexto {
  id: number;
  id_sessao_usuario: number;
  id_usuario: number;
  id_atendimento: number;
  id_entidade: number;
  id_unidade: number;
  id_local: number;
  acao: string;
  detalhes: Record<string, unknown>;
  criado_em: string;
}

export interface AuditoriaContextoCreate {
  acao?: string;
  detalhes?: Record<string, unknown>;
  criado_em?: string;
}

export interface AuditoriaContextoUpdate {
  acao?: string;
  detalhes?: Record<string, unknown>;
  criado_em?: string;
}
