export interface TabelaTuss {
  codigo_tuss: string;
  descricao: string;
  valor_honorario: number;
  valor_custo_operacional: number;
  id_entidade: number;
}

export interface TabelaTussCreate {
  codigo_tuss?: string;
  descricao?: string;
  valor_honorario?: number;
  valor_custo_operacional?: number;
}

export interface TabelaTussUpdate {
  codigo_tuss?: string;
  descricao?: string;
  valor_honorario?: number;
  valor_custo_operacional?: number;
}
