export interface AlertaConsumo {
  id_alerta_consumo: number;
  id_alerta: number;
  id_usuario: number;
  acao: string;
  observacao: string;
  id_sessao_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface AlertaConsumoCreate {
  acao?: string;
  observacao?: string;
  criado_em?: string;
}

export interface AlertaConsumoUpdate {
  acao?: string;
  observacao?: string;
  criado_em?: string;
}
