export interface StatusTimeout {
  status: string;
  tempo_max_segundos: number;
  status_fallback: string;
  ativo: number;
  id_entidade: number;
}

export interface StatusTimeoutCreate {
  status?: string;
  tempo_max_segundos?: number;
  status_fallback?: string;
  ativo?: number;
}

export interface StatusTimeoutUpdate {
  status?: string;
  tempo_max_segundos?: number;
  status_fallback?: string;
  ativo?: number;
}
