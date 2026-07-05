export interface InternacaoDietas {
  id: number;
  id_prescricao_item: number;
  consistencia: string;
  restricao: string;
  volume_total_dia: number;
  id_entidade: number;
}

export interface InternacaoDietasCreate {
  consistencia?: string;
  restricao?: string;
  volume_total_dia?: number;
}

export interface InternacaoDietasUpdate {
  consistencia?: string;
  restricao?: string;
  volume_total_dia?: number;
}
