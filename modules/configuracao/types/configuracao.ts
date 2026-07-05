export interface Configuracao {
  chave: string;
  valor: string;
  id_entidade: number;
}

export interface ConfiguracaoCreate {
  chave?: string;
  valor?: string;
}

export interface ConfiguracaoUpdate {
  chave?: string;
  valor?: string;
}
