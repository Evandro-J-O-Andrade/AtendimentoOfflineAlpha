export interface Viatura {
  id_viatura: number;
  id_unidade: number;
  prefixo: string;
  tipo: string;
  ativo: number;
  id_entidade: number;
}

export interface ViaturaCreate {
  prefixo?: string;
  tipo?: string;
  ativo?: number;
}

export interface ViaturaUpdate {
  prefixo?: string;
  tipo?: string;
  ativo?: number;
}
