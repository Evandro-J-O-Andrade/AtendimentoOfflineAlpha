export interface FfaSinaisVitais {
  id_sinais: number;
  id_ffa: number;
  id_fila: number;
  id_sessao_usuario: number;
  id_local_operacional: number;
  id_usuario: number;
  data_coleta: string;
  pressao_sistolica: number;
  pressao_diastolica: number;
  freq_cardiaca: number;
  freq_respiratoria: number;
  temperatura: number;
  saturacao: number;
  glicemia: number;
  observacao: string;
  criado_em: string;
  id_entidade: number;
}

export interface FfaSinaisVitaisCreate {
  data_coleta?: string;
  pressao_sistolica?: number;
  pressao_diastolica?: number;
  freq_cardiaca?: number;
  freq_respiratoria?: number;
  temperatura?: number;
  saturacao?: number;
  glicemia?: number;
  observacao?: string;
  criado_em?: string;
}

export interface FfaSinaisVitaisUpdate {
  data_coleta?: string;
  pressao_sistolica?: number;
  pressao_diastolica?: number;
  freq_cardiaca?: number;
  freq_respiratoria?: number;
  temperatura?: number;
  saturacao?: number;
  glicemia?: number;
  observacao?: string;
  criado_em?: string;
}
