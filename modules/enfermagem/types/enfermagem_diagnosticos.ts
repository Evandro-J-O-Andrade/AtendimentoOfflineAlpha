export interface EnfermagemDiagnosticos {
  id: number;
  id_ffa: number;
  diagnostico_selecionado: string;
  tipo: string;
  observacao: string;
  id_usuario: number;
  data_hora: string;
  id_entidade: number;
}

export interface EnfermagemDiagnosticosCreate {
  diagnostico_selecionado?: string;
  tipo?: string;
  observacao?: string;
  data_hora?: string;
}

export interface EnfermagemDiagnosticosUpdate {
  diagnostico_selecionado?: string;
  tipo?: string;
  observacao?: string;
  data_hora?: string;
}
