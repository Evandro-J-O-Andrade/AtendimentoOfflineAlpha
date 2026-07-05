export interface FluxoStatus {
  id_fluxo_status: number;
  codigo: string;
  descricao: string;
  tipo: string;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface FluxoStatusCreate {
  codigo?: string;
  descricao?: string;
  tipo?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface FluxoStatusUpdate {
  codigo?: string;
  descricao?: string;
  tipo?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
