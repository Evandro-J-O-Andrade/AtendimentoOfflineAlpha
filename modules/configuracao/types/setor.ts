export interface Setor {
  id_setor: number;
  id_unidade: number;
  nome: string;
  tipo: string;
  ramal: string;
  responsavel_id: number;
  ativo: number;
  id_entidade: number;
}

export interface SetorCreate {
  nome?: string;
  tipo?: string;
  ramal?: string;
  ativo?: number;
}

export interface SetorUpdate {
  nome?: string;
  tipo?: string;
  ramal?: string;
  ativo?: number;
}
