export interface SenhaStatus {
  id_senha_status: number;
  codigo: string;
  descricao: string;
  ativo: number;
  ordem_fluxo: number;
  id_entidade: number;
}

export interface SenhaStatusCreate {
  codigo?: string;
  descricao?: string;
  ativo?: number;
  ordem_fluxo?: number;
}

export interface SenhaStatusUpdate {
  codigo?: string;
  descricao?: string;
  ativo?: number;
  ordem_fluxo?: number;
}
