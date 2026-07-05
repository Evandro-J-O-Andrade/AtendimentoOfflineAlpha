export interface FaturamentoCodigo {
  id_codigo: number;
  sistema: string;
  codigo: string;
  tipo: string;
  descricao: string;
  unidade_medida: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface FaturamentoCodigoCreate {
  sistema?: string;
  codigo?: string;
  tipo?: string;
  descricao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface FaturamentoCodigoUpdate {
  sistema?: string;
  codigo?: string;
  tipo?: string;
  descricao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
