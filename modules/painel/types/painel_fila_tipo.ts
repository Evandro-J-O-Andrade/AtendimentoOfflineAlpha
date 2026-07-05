export interface PainelFilaTipo {
  id_painel: number;
  tipo_fila: string;
  id_entidade: number;
}

export interface PainelFilaTipoCreate {
  tipo_fila?: string;
}

export interface PainelFilaTipoUpdate {
  tipo_fila?: string;
}
