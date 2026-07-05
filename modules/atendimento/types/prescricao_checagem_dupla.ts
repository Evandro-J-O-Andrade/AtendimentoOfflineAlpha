export interface PrescricaoChecagemDupla {
  id_dupla_checagem: number;
  id_checagem_principal: number;
  id_usuario_testemunha: number;
  data_hora: string;
  id_entidade: number;
}

export interface PrescricaoChecagemDuplaCreate {
  data_hora?: string;
}

export interface PrescricaoChecagemDuplaUpdate {
  data_hora?: string;
}
