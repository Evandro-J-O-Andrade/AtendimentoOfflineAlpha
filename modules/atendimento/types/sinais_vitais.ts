export interface SinaisVitais {
  id_sinal: number;
  id_atendimento: number;
  id_usuario: number;
  frequencia_cardiaca: number;
  pressao_sistolica: number;
  pressao_diastolica: number;
  temperatura: number;
  saturacao_o2: number;
  dor: number;
  criado_em: string;
  id_entidade: number;
}

export interface SinaisVitaisCreate {
  frequencia_cardiaca?: number;
  pressao_sistolica?: number;
  pressao_diastolica?: number;
  temperatura?: number;
  saturacao_o2?: number;
  dor?: number;
  criado_em?: string;
}

export interface SinaisVitaisUpdate {
  frequencia_cardiaca?: number;
  pressao_sistolica?: number;
  pressao_diastolica?: number;
  temperatura?: number;
  saturacao_o2?: number;
  dor?: number;
  criado_em?: string;
}
