export interface AlmoxarifadoCentral {
  id: number;
  id_produto: number;
  lote: string;
  validade: string;
  quantidade_atual: number;
  quantidade_minima: number;
  nfe_chave_acesso: string;
  id_unidade: number;
  id_entidade: number;
}

export interface AlmoxarifadoCentralCreate {
  lote?: string;
  nfe_chave_acesso?: string;
}

export interface AlmoxarifadoCentralUpdate {
  lote?: string;
  nfe_chave_acesso?: string;
}
