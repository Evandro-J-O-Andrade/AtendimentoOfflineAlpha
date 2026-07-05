export interface LabEvento {
  id: number;
  id_pedido: number;
  status_novo: string;
  id_usuario: number;
  data_hora: string;
  payload_auditoria: string;
  id_entidade: number;
}

export interface LabEventoCreate {
  status_novo?: string;
  data_hora?: string;
  payload_auditoria?: string;
}

export interface LabEventoUpdate {
  status_novo?: string;
  data_hora?: string;
  payload_auditoria?: string;
}
