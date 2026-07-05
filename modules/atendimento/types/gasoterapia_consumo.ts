export interface GasoterapiaConsumo {
  id: number;
  id_atendimento: number;
  id_leito: number;
  tipo_gas: string;
  litros_por_minuto: number;
  data_inicio: string;
  data_fim: string;
  status: string;
  id_usuario_registro: number;
  id_entidade: number;
}

export interface GasoterapiaConsumoCreate {
  tipo_gas?: string;
  litros_por_minuto?: number;
  data_inicio?: string;
  data_fim?: string;
  status?: string;
}

export interface GasoterapiaConsumoUpdate {
  tipo_gas?: string;
  litros_por_minuto?: number;
  data_inicio?: string;
  data_fim?: string;
  status?: string;
}
