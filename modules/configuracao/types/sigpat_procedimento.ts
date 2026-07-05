export interface SigpatProcedimento {
  id_sigpat: number;
  codigo: string;
  descricao: string;
  tipo: string;
  grupo: string;
  subgrupo: string;
  ativo: number;
  setor_execucao: string;
  gera_faturamento: number;
  exige_coleta: number;
  id_entidade: number;
}

export interface SigpatProcedimentoCreate {
  codigo?: string;
  descricao?: string;
  tipo?: string;
  grupo?: string;
  subgrupo?: string;
  ativo?: number;
  setor_execucao?: string;
  gera_faturamento?: number;
  exige_coleta?: number;
}

export interface SigpatProcedimentoUpdate {
  codigo?: string;
  descricao?: string;
  tipo?: string;
  grupo?: string;
  subgrupo?: string;
  ativo?: number;
  setor_execucao?: string;
  gera_faturamento?: number;
  exige_coleta?: number;
}
