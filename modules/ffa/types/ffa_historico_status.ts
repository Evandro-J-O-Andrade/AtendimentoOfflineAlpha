export interface FfaHistoricoStatus {
  id: number;
  id_ffa: number;
  status_anterior: string;
  status_novo: string;
  data_mudanca: string;
  id_usuario_acao: number;
  id_entidade: number;
}

export interface FfaHistoricoStatusCreate {
  status_anterior?: string;
  status_novo?: string;
  data_mudanca?: string;
}

export interface FfaHistoricoStatusUpdate {
  status_anterior?: string;
  status_novo?: string;
  data_mudanca?: string;
}
