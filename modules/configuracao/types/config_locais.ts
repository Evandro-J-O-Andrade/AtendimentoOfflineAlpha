export interface ConfigLocais {
  id: number;
  id_unidade: number;
  nome: string;
  tipo: string;
  ativo: number;
  id_entidade: number;
}

export interface ConfigLocaisCreate {
  nome?: string;
  tipo?: string;
  ativo?: number;
}

export interface ConfigLocaisUpdate {
  nome?: string;
  tipo?: string;
  ativo?: number;
}
