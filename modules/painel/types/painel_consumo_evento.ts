export interface PainelConsumoEvento {
  id_consumo: number;
  origem: string;
  id_evento: number;
  painel_tipo: string;
  id_local_operacional: number;
  consumido_em: string;
  id_entidade: number;
}

export interface PainelConsumoEventoCreate {
  origem?: string;
  painel_tipo?: string;
}

export interface PainelConsumoEventoUpdate {
  origem?: string;
  painel_tipo?: string;
}
