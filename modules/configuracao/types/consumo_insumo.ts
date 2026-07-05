export interface ConsumoInsumo {
  id_consumo: number;
  id_ffa: number;
  origem: string;
  id_produto: number;
  quantidade: number;
  usado_em: string;
  registrado_por: number;
  observacao: string;
  id_entidade: number;
}

export interface ConsumoInsumoCreate {
  origem?: string;
  usado_em?: string;
  registrado_por?: number;
  observacao?: string;
}

export interface ConsumoInsumoUpdate {
  origem?: string;
  usado_em?: string;
  registrado_por?: number;
  observacao?: string;
}
