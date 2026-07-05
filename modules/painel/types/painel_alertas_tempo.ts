export interface PainelAlertasTempo {
  id: number;
  id_senha: number;
  mensagem: string;
  nivel: string;
  data_alerta: string;
  id_entidade: number;
}

export interface PainelAlertasTempoCreate {
  mensagem?: string;
  nivel?: string;
  data_alerta?: string;
}

export interface PainelAlertasTempoUpdate {
  mensagem?: string;
  nivel?: string;
  data_alerta?: string;
}
