export interface PlantaoModelo {
  id_plantao_modelo: number;
  nome: string;
  atravessa_dia: number;
  horas_previstas: number;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface PlantaoModeloCreate {
  nome?: string;
  atravessa_dia?: number;
  horas_previstas?: number;
  ativo?: number;
  criado_em?: string;
}

export interface PlantaoModeloUpdate {
  nome?: string;
  atravessa_dia?: number;
  horas_previstas?: number;
  ativo?: number;
  criado_em?: string;
}
