export interface GasoterapiaConsumoEvento {
  id_evento: number;
  id_consumo: number;
  evento: string;
  detalhe: string;
  id_usuario: number;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface GasoterapiaConsumoEventoCreate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}

export interface GasoterapiaConsumoEventoUpdate {
  evento?: string;
  detalhe?: string;
  criado_em?: string;
}
