export interface VendaEvento {
  id_evento: number;
  id_venda: number;
  tipo: string;
  descricao: string;
  criado_em: string;
  id_usuario: number;
  id_entidade: number;
}

export interface VendaEventoCreate {
  tipo?: string;
  descricao?: string;
  criado_em?: string;
}

export interface VendaEventoUpdate {
  tipo?: string;
  descricao?: string;
  criado_em?: string;
}
