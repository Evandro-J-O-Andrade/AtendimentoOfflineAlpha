export interface ExameFisico {
  id_exame: number;
  id_atendimento: number;
  descricao: string;
  id_usuario: number;
  data_hora: string;
  id_entidade: number;
}

export interface ExameFisicoCreate {
  descricao?: string;
  data_hora?: string;
}

export interface ExameFisicoUpdate {
  descricao?: string;
  data_hora?: string;
}
