export interface MdCid10 {
  competencia: string;
  codigo: string;
  descricao: string;
  categoria: string;
  subcategoria: string;
  capitulo: string;
  sexo_restricao: string;
  idade_min_meses: number;
  idade_max_meses: number;
  ativo: number;
  atualizado_em: string;
  id_entidade: number;
}

export interface MdCid10Create {
  competencia?: string;
  codigo?: string;
  descricao?: string;
  categoria?: string;
  subcategoria?: string;
  capitulo?: string;
  sexo_restricao?: string;
  ativo?: number;
  atualizado_em?: string;
}

export interface MdCid10Update {
  competencia?: string;
  codigo?: string;
  descricao?: string;
  categoria?: string;
  subcategoria?: string;
  capitulo?: string;
  sexo_restricao?: string;
  ativo?: number;
  atualizado_em?: string;
}
