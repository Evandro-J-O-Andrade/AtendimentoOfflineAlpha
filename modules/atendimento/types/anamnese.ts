export interface Anamnese {
  id_anamnese: number;
  id_atendimento: number;
  descricao: string;
  id_usuario: number;
  data_hora: string;
  id_entidade: number;
}

export interface AnamneseCreate {
  descricao?: string;
  data_hora?: string;
}

export interface AnamneseUpdate {
  descricao?: string;
  data_hora?: string;
}
