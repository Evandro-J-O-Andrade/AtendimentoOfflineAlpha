export interface EscalaMedica {
  id: number;
  id_usuario_medico: number;
  id_unidade: number;
  data_plantao: string;
  turno: string;
  status_presenca: string;
  id_substituto: number;
  id_entidade: number;
}

export interface EscalaMedicaCreate {
  data_plantao?: string;
  turno?: string;
  status_presenca?: string;
}

export interface EscalaMedicaUpdate {
  data_plantao?: string;
  turno?: string;
  status_presenca?: string;
}
