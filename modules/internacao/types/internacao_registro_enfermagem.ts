export interface InternacaoRegistroEnfermagem {
  id_internacao_registro_enfermagem: number;
  id_internacao: number;
  data_hora: string;
  turno: string;
  periodicidade: string;
  pressao_arterial: string;
  temperatura: number;
  frequencia_cardiaca: number;
  frequencia_respiratoria: number;
  saturacao_o2: number;
  glicemia: number;
  entradas_ml: number;
  saidas_ml: number;
  diurese_evacuacao: string;
  observacoes: string;
  id_usuario_responsavel: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface InternacaoRegistroEnfermagemCreate {
  data_hora?: string;
  turno?: string;
  pressao_arterial?: string;
  temperatura?: number;
  frequencia_cardiaca?: number;
  frequencia_respiratoria?: number;
  saturacao_o2?: number;
  glicemia?: number;
  entradas_ml?: number;
  diurese_evacuacao?: string;
  observacoes?: string;
  criado_em?: string;
}

export interface InternacaoRegistroEnfermagemUpdate {
  data_hora?: string;
  turno?: string;
  pressao_arterial?: string;
  temperatura?: number;
  frequencia_cardiaca?: number;
  frequencia_respiratoria?: number;
  saturacao_o2?: number;
  glicemia?: number;
  entradas_ml?: number;
  diurese_evacuacao?: string;
  observacoes?: string;
  criado_em?: string;
}
