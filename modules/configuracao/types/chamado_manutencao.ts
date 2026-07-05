export interface ChamadoManutencao {
  id_chamado: number;
  id_setor: number;
  origem: string;
  tipo_problema: string;
  descricao: string;
  prioridade: string;
  status: string;
  aberto_por: number;
  aberto_em: string;
  fechado_em: string;
  id_entidade: number;
}

export interface ChamadoManutencaoCreate {
  origem?: string;
  tipo_problema?: string;
  descricao?: string;
  status?: string;
  aberto_por?: number;
  aberto_em?: string;
  fechado_em?: string;
}

export interface ChamadoManutencaoUpdate {
  origem?: string;
  tipo_problema?: string;
  descricao?: string;
  status?: string;
  aberto_por?: number;
  aberto_em?: string;
  fechado_em?: string;
}
