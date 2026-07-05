export interface FarmaciaExternoEvento {
  id_evento: number;
  id_atendimento: number;
  tipo: string;
  descricao: string;
  criado_em: string;
  id_usuario: number;
  id_entidade: number;
}

export interface FarmaciaExternoEventoCreate {
  tipo?: string;
  descricao?: string;
  criado_em?: string;
}

export interface FarmaciaExternoEventoUpdate {
  tipo?: string;
  descricao?: string;
  criado_em?: string;
}
