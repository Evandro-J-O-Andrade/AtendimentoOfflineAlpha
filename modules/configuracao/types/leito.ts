export interface Leito {
  id_leito: number;
  id_setor: number;
  identificacao: string;
  status: string;
  id_entidade: number;
}

export interface LeitoCreate {
  status?: string;
}

export interface LeitoUpdate {
  status?: string;
}
