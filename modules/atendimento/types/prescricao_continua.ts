export interface PrescricaoContinua {
  id_prescricao: number;
  id_atendimento: number;
  tipo: string;
  id_medico: number;
  data_hora: string;
  ativa: number;
  id_entidade: number;
}

export interface PrescricaoContinuaCreate {
  tipo?: string;
  data_hora?: string;
  ativa?: number;
}

export interface PrescricaoContinuaUpdate {
  tipo?: string;
  data_hora?: string;
  ativa?: number;
}
