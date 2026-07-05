export interface ExameHistorico {
  id: number;
  id_pedido: number;
  evento: string;
  descricao: string;
  id_usuario: number;
  criado_em: string;
  id_entidade: number;
}

export interface ExameHistoricoCreate {
  evento?: string;
  descricao?: string;
  criado_em?: string;
}

export interface ExameHistoricoUpdate {
  evento?: string;
  descricao?: string;
  criado_em?: string;
}
