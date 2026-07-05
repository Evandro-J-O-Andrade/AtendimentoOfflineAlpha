export interface EvolucaoMedica {
  id_evolucao: number;
  id_internacao: number;
  descricao: string;
  id_medico: number;
  data_hora: string;
  id_entidade: number;
}

export interface EvolucaoMedicaCreate {
  descricao?: string;
  data_hora?: string;
}

export interface EvolucaoMedicaUpdate {
  descricao?: string;
  data_hora?: string;
}
