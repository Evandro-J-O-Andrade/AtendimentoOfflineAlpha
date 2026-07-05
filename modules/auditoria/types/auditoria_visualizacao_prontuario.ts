export interface AuditoriaVisualizacaoProntuario {
  id: number;
  id_usuario: number;
  id_atendimento: number;
  ip_acesso: string;
  data_hora: string;
  contexto: string;
  id_entidade: number;
}

export interface AuditoriaVisualizacaoProntuarioCreate {
  ip_acesso?: string;
  data_hora?: string;
  contexto?: string;
}

export interface AuditoriaVisualizacaoProntuarioUpdate {
  ip_acesso?: string;
  data_hora?: string;
  contexto?: string;
}
