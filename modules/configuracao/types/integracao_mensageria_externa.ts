export interface IntegracaoMensageriaExterna {
  id: number;
  id_atendimento: number;
  provedor_externo: string;
  tipo_mensagem: string;
  status_processamento: string;
  data_recebimento: string;
  id_entidade: number;
}

export interface IntegracaoMensageriaExternaCreate {
  provedor_externo?: string;
  tipo_mensagem?: string;
  status_processamento?: string;
  data_recebimento?: string;
}

export interface IntegracaoMensageriaExternaUpdate {
  provedor_externo?: string;
  tipo_mensagem?: string;
  status_processamento?: string;
  data_recebimento?: string;
}
