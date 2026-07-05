export interface PacienteAlertas {
  id: number;
  id_pessoa: number;
  tipo_alerta: string;
  descricao: string;
  grau_severidade: string;
  data_registro: string;
  id_entidade: number;
}

export interface PacienteAlertasCreate {
  tipo_alerta?: string;
  descricao?: string;
  data_registro?: string;
}

export interface PacienteAlertasUpdate {
  tipo_alerta?: string;
  descricao?: string;
  data_registro?: string;
}
