export interface PrescricaoKitItens {
  id: number;
  id_kit: number;
  item_nome: string;
  dose: string;
  via: string;
  frequencia: string;
  id_entidade: number;
}

export interface PrescricaoKitItensCreate {
  item_nome?: string;
  dose?: string;
  via?: string;
  frequencia?: string;
}

export interface PrescricaoKitItensUpdate {
  item_nome?: string;
  dose?: string;
  via?: string;
  frequencia?: string;
}
