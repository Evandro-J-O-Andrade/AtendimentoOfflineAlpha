export interface TransporteAmbulancia {
  id: number;
  id_senha: number;
  placa_veiculo: string;
  condutor_nome: string;
  tipo_equipe: string;
  km_saida: number;
  km_chegada: number;
  data_hora_acionamento: string;
  id_entidade: number;
}

export interface TransporteAmbulanciaCreate {
  placa_veiculo?: string;
  condutor_nome?: string;
  tipo_equipe?: string;
  km_chegada?: number;
  data_hora_acionamento?: string;
}

export interface TransporteAmbulanciaUpdate {
  placa_veiculo?: string;
  condutor_nome?: string;
  tipo_equipe?: string;
  km_chegada?: number;
  data_hora_acionamento?: string;
}
