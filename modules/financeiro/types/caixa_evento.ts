export interface CaixaEvento {
  id_evento: number;
  id_caixa: number;
  tipo: string;
  descricao: string;
  criado_em: string;
  id_usuario: number;
  id_entidade: number;
}

export interface CaixaEventoCreate {
  tipo?: string;
  descricao?: string;
  criado_em?: string;
}

export interface CaixaEventoUpdate {
  tipo?: string;
  descricao?: string;
  criado_em?: string;
}
