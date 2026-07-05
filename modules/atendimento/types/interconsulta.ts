export interface Interconsulta {
  id_interconsulta: number;
  id_internacao: number;
  id_especialidade: number;
  motivo: string;
  status: string;
  data_hora: string;
  id_entidade: number;
}

export interface InterconsultaCreate {
  motivo?: string;
  status?: string;
  data_hora?: string;
}

export interface InterconsultaUpdate {
  motivo?: string;
  status?: string;
  data_hora?: string;
}
