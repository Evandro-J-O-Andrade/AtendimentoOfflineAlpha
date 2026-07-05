export interface ConsumoLimpeza {
  id_consumo: number;
  id_setor: number;
  id_produto: number;
  quantidade: number;
  unidade: string;
  consumido_em: string;
  registrado_por: number;
  motivo: string;
  observacao: string;
  id_entidade: number;
}

export interface ConsumoLimpezaCreate {
  registrado_por?: number;
  motivo?: string;
  observacao?: string;
}

export interface ConsumoLimpezaUpdate {
  registrado_por?: number;
  motivo?: string;
  observacao?: string;
}
