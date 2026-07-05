export interface PrescricaoItem {
  id_item: number;
  id_prescricao: number;
  descricao: string;
  dose: string;
  via: string;
  posologia: string;
  observacao: string;
  id_lote: number;
  dispensado_em: string;
  id_usuario_dispensacao: number;
  status: string;
  id_entidade: number;
}

export interface PrescricaoItemCreate {
  descricao?: string;
  dose?: string;
  via?: string;
  posologia?: string;
  observacao?: string;
  dispensado_em?: string;
  status?: string;
}

export interface PrescricaoItemUpdate {
  descricao?: string;
  dose?: string;
  via?: string;
  posologia?: string;
  observacao?: string;
  dispensado_em?: string;
  status?: string;
}
