export interface AuditoriaFila {
  id: number;
  id_fila: number;
  id_usuario: number;
  acao: string;
  timestamp: string;
  id_entidade: number;
}

export interface AuditoriaFilaCreate {
  acao?: string;
  timestamp?: string;
}

export interface AuditoriaFilaUpdate {
  acao?: string;
  timestamp?: string;
}
