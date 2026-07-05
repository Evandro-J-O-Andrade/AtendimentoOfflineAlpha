export interface RegraTimeout {
  status: string;
  minutos: number;
  evento_timeout: string;
  id_entidade: number;
}

export interface RegraTimeoutCreate {
  status?: string;
  minutos?: number;
  evento_timeout?: string;
}

export interface RegraTimeoutUpdate {
  status?: string;
  minutos?: number;
  evento_timeout?: string;
}
