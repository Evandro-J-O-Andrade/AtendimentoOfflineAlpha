export interface AuthParametro {
  id_parametro: number;
  chave: string;
  valor: string;
  descricao: string;
  tipo_parametro: string;
  ativo: number;
  id_entidade: number;
}

export interface AuthParametroCreate {
  chave?: string;
  valor?: string;
  descricao?: string;
  tipo_parametro?: string;
  ativo?: number;
}

export interface AuthParametroUpdate {
  chave?: string;
  valor?: string;
  descricao?: string;
  tipo_parametro?: string;
  ativo?: number;
}
