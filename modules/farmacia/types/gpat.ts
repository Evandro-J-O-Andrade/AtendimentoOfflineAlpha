export interface Gpat {
  id_gpat: number;
  id_ffa: number;
  id_codigo_universal: number;
  codigo_gpat: string;
  barcode_gpat: string;
  origem: string;
  observacao: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface GpatCreate {
  codigo_gpat?: string;
  barcode_gpat?: string;
  origem?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface GpatUpdate {
  codigo_gpat?: string;
  barcode_gpat?: string;
  origem?: string;
  observacao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
