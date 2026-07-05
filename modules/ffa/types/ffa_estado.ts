export interface FfaEstado {
  id_estado: number;
  nome: string;
  descricao: string;
  ativo: number;
  id_entidade: number;
}

export interface FfaEstadoCreate {
  nome?: string;
  descricao?: string;
  ativo?: number;
}

export interface FfaEstadoUpdate {
  nome?: string;
  descricao?: string;
  ativo?: number;
}
