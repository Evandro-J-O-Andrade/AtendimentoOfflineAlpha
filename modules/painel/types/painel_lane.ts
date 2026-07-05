export interface PainelLane {
  id_painel: number;
  lane: string;
  id_entidade: number;
}

export interface PainelLaneCreate {
  lane?: string;
}

export interface PainelLaneUpdate {
  lane?: string;
}
