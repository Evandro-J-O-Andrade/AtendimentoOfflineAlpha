export interface PrescricaoChecagem {
  id_checagem: number;
  id_prescricao_item: number;
  id_usuario_enfermeiro: number;
  data_hora_checagem: string;
  status: string;
  observacao: string;
  id_entidade: number;
}

export interface PrescricaoChecagemCreate {
  data_hora_checagem?: string;
  status?: string;
  observacao?: string;
}

export interface PrescricaoChecagemUpdate {
  data_hora_checagem?: string;
  status?: string;
  observacao?: string;
}
