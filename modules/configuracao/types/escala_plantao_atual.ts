export interface EscalaPlantaoAtual {
  id: number;
  id_usuario: number;
  id_unidade: number;
  id_setor: number;
  registro_profissional: string;
  data_inicio: string;
  data_fim: string;
  status_plantao: string;
  id_entidade: number;
}

export interface EscalaPlantaoAtualCreate {
  registro_profissional?: string;
  data_inicio?: string;
  data_fim?: string;
  status_plantao?: string;
}

export interface EscalaPlantaoAtualUpdate {
  registro_profissional?: string;
  data_inicio?: string;
  data_fim?: string;
  status_plantao?: string;
}
