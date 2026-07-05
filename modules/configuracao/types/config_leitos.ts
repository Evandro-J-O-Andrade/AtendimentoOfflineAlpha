export interface ConfigLeitos {
  id: number;
  id_unidade: number;
  identificacao: string;
  tipo: string;
  status_ocupacao: string;
  id_atendimento_atual: number;
  id_entidade: number;
}

export interface ConfigLeitosCreate {
  tipo?: string;
  status_ocupacao?: string;
}

export interface ConfigLeitosUpdate {
  tipo?: string;
  status_ocupacao?: string;
}
