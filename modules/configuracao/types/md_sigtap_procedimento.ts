export interface MdSigtapProcedimento {
  competencia: string;
  codigo: string;
  nome: string;
  complexidade: string;
  sexo_restricao: string;
  idade_min_meses: number;
  idade_max_meses: number;
  valor_sa: number;
  valor_sh: number;
  valor_sus: number;
  ativo: number;
  atualizado_em: string;
  id_entidade: number;
}

export interface MdSigtapProcedimentoCreate {
  competencia?: string;
  codigo?: string;
  nome?: string;
  sexo_restricao?: string;
  valor_sa?: number;
  valor_sh?: number;
  valor_sus?: number;
  ativo?: number;
  atualizado_em?: string;
}

export interface MdSigtapProcedimentoUpdate {
  competencia?: string;
  codigo?: string;
  nome?: string;
  sexo_restricao?: string;
  valor_sa?: number;
  valor_sh?: number;
  valor_sus?: number;
  ativo?: number;
  atualizado_em?: string;
}
