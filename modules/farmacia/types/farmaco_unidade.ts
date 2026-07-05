export interface FarmacoUnidade {
  id_farmaco: number;
  id_cidade: number;
  cota_minima: number;
  cota_maxima: number;
  atualizado_por: number;
  atualizado_em: string;
  id_entidade: number;
}

export interface FarmacoUnidadeCreate {
  cota_minima?: number;
  cota_maxima?: number;
  atualizado_por?: number;
  atualizado_em?: string;
}

export interface FarmacoUnidadeUpdate {
  cota_minima?: number;
  cota_maxima?: number;
  atualizado_por?: number;
  atualizado_em?: string;
}
