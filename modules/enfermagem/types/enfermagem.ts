export interface Enfermagem {
  id_usuario: number;
  coren: string;
  uf_coren: string;
  tipo: string;
  id_entidade: number;
}

export interface EnfermagemCreate {
  coren?: string;
  uf_coren?: string;
  tipo?: string;
}

export interface EnfermagemUpdate {
  coren?: string;
  uf_coren?: string;
  tipo?: string;
}
