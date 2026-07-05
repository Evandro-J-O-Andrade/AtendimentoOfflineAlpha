export interface FaturamentoSigtap {
  id: number;
  codigo_procedimento: string;
  nome_procedimento: string;
  valor_sh: number;
  valor_sa: number;
  complexidade: string;
  id_entidade: number;
}

export interface FaturamentoSigtapCreate {
  codigo_procedimento?: string;
  nome_procedimento?: string;
  valor_sh?: number;
  valor_sa?: number;
}

export interface FaturamentoSigtapUpdate {
  codigo_procedimento?: string;
  nome_procedimento?: string;
  valor_sh?: number;
  valor_sa?: number;
}
