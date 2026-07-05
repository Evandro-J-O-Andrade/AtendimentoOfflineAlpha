export interface PlantaoEscala {
  id_plantao_escala: number;
  id_unidade: number;
  id_funcionario: number;
  data: string;
  turno: string;
  id_plantao_modelo: number;
  tipo_plantao: string;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PlantaoEscalaCreate {
  data?: string;
  turno?: string;
  tipo_plantao?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PlantaoEscalaUpdate {
  data?: string;
  turno?: string;
  tipo_plantao?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
