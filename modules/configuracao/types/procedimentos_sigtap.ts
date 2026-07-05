export interface ProcedimentosSigtap {
  codigo_procedimento: string;
  nome_procedimento: string;
  valor_sus: number;
  id_entidade: number;
}

export interface ProcedimentosSigtapCreate {
  codigo_procedimento?: string;
  nome_procedimento?: string;
  valor_sus?: number;
}

export interface ProcedimentosSigtapUpdate {
  codigo_procedimento?: string;
  nome_procedimento?: string;
  valor_sus?: number;
}
