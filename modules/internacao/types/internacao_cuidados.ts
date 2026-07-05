export interface InternacaoCuidados {
  id: number;
  id_prescricao_item: number;
  tipo_cuidado: string;
  posicionamento: string;
  frequencia_checagem: number;
  id_entidade: number;
}

export interface InternacaoCuidadosCreate {
  posicionamento?: string;
  frequencia_checagem?: number;
}

export interface InternacaoCuidadosUpdate {
  posicionamento?: string;
  frequencia_checagem?: number;
}
