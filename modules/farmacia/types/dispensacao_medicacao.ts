export interface DispensacaoMedicacao {
  id_dispensacao: number;
  id_ordem: number;
  id_item: number;
  id_farmaco: number;
  id_lote: number;
  quantidade: number;
  id_usuario_dispensador: number;
  data_hora: string;
  status: string;
  observacao: string;
  id_entidade: number;
}

export interface DispensacaoMedicacaoCreate {
  data_hora?: string;
  status?: string;
  observacao?: string;
}

export interface DispensacaoMedicacaoUpdate {
  data_hora?: string;
  status?: string;
  observacao?: string;
}
