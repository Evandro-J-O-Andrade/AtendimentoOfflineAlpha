export interface AtendimentoSinaisVitais {
  id: number;
  id_atendimento: number;
  id_usuario_registro: number;
  pa_sistolica: number;
  pa_diastolica: number;
  frequencia_cardiaca: number;
  frequencia_respiratoria: number;
  temperatura: number;
  saturacao_o2: number;
  hgt: number;
  data_registro: string;
  id_entidade: number;
}

export interface AtendimentoSinaisVitaisCreate {
  pa_sistolica?: number;
  pa_diastolica?: number;
  frequencia_cardiaca?: number;
  frequencia_respiratoria?: number;
  temperatura?: number;
  saturacao_o2?: number;
  hgt?: number;
  data_registro?: string;
}

export interface AtendimentoSinaisVitaisUpdate {
  pa_sistolica?: number;
  pa_diastolica?: number;
  frequencia_cardiaca?: number;
  frequencia_respiratoria?: number;
  temperatura?: number;
  saturacao_o2?: number;
  hgt?: number;
  data_registro?: string;
}
