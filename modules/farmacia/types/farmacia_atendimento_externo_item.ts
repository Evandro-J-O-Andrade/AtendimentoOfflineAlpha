export interface FarmaciaAtendimentoExternoItem {
  id_item: number;
  id_atendimento: number;
  id_farmaco: number;
  quantidade_total: number;
  posologia: string;
  dias: number;
  status: string;
  criado_em: string;
  criado_por: number;
  atualizado_em: string;
  atualizado_por: number;
  id_lote: number;
  id_local_estoque: number;
  id_entidade: number;
}

export interface FarmaciaAtendimentoExternoItemCreate {
  posologia?: string;
  dias?: number;
  status?: string;
  criado_em?: string;
  criado_por?: number;
  atualizado_em?: string;
  atualizado_por?: number;
}

export interface FarmaciaAtendimentoExternoItemUpdate {
  posologia?: string;
  dias?: number;
  status?: string;
  criado_em?: string;
  criado_por?: number;
  atualizado_em?: string;
  atualizado_por?: number;
}
