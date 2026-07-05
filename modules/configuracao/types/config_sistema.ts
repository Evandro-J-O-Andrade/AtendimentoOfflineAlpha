export interface ConfigSistema {
  id: number;
  id_unidade: number;
  parametro: string;
  valor: string;
  id_entidade: number;
}

export interface ConfigSistemaCreate {
  parametro?: string;
  valor?: string;
}

export interface ConfigSistemaUpdate {
  parametro?: string;
  valor?: string;
}
