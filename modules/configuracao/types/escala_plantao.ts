export interface EscalaPlantao {
  id_escala: number;
  id_unidade: number;
  id_sistema: number;
  data: string;
  id_plantao_modelo: number;
  observacao: string;
  criado_em: string;
  id_entidade: number;
}

export interface EscalaPlantaoCreate {
  data?: string;
  observacao?: string;
  criado_em?: string;
}

export interface EscalaPlantaoUpdate {
  data?: string;
  observacao?: string;
  criado_em?: string;
}
