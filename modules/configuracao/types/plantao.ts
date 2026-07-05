export interface Plantao {
  id_plantao: number;
  id_unidade: number;
  id_local: number;
  id_funcionario: number;
  tipo_plantao: string;
  inicio_plantao: string;
  fim_plantao: string;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PlantaoCreate {
  tipo_plantao?: string;
  inicio_plantao?: string;
  fim_plantao?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PlantaoUpdate {
  tipo_plantao?: string;
  inicio_plantao?: string;
  fim_plantao?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
