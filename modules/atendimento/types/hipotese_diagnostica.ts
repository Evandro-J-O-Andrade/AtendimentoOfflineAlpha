export interface HipoteseDiagnostica {
  id_hipotese: number;
  id_atendimento: number;
  cid10: string;
  principal: number;
  id_medico: number;
  data_hora: string;
  id_entidade: number;
}

export interface HipoteseDiagnosticaCreate {
  principal?: number;
  data_hora?: string;
}

export interface HipoteseDiagnosticaUpdate {
  principal?: number;
  data_hora?: string;
}
