export interface GpatItem {
  id_gpat_item: number;
  id_gpat: number;
  id_farmaco: number;
  quantidade_total: number;
  unidade_medida: string;
  posologia: string;
  dias: number;
  observacao: string;
  status: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface GpatItemCreate {
  posologia?: string;
  dias?: number;
  observacao?: string;
  status?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface GpatItemUpdate {
  posologia?: string;
  dias?: number;
  observacao?: string;
  status?: string;
  criado_em?: string;
  atualizado_em?: string;
}
