export interface TotemFeedback {
  id_feedback: number;
  id_senha: number;
  origem: string;
  nota: number;
  comentario: string;
  data_hora: string;
  id_entidade: number;
}

export interface TotemFeedbackCreate {
  origem?: string;
  nota?: number;
  comentario?: string;
  data_hora?: string;
}

export interface TotemFeedbackUpdate {
  origem?: string;
  nota?: number;
  comentario?: string;
  data_hora?: string;
}
