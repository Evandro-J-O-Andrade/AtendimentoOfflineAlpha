export interface ConsumoManutencao {
  id_consumo: number;
  id_chamado: number;
  id_produto: number;
  quantidade: number;
  unidade: string;
  consumido_em: string;
  registrado_por: number;
  id_entidade: number;
}

export interface ConsumoManutencaoCreate {
  registrado_por?: number;
}

export interface ConsumoManutencaoUpdate {
  registrado_por?: number;
}
