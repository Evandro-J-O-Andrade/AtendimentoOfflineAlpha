export interface HospitalLeitos {
  id_leito: number;
  id_unidade: number;
  nome_leito: string;
  tipo_leito: string;
  status: string;
  id_atendimento_atual: number;
  id_entidade: number;
}

export interface HospitalLeitosCreate {
  nome_leito?: string;
  tipo_leito?: string;
  status?: string;
}

export interface HospitalLeitosUpdate {
  nome_leito?: string;
  tipo_leito?: string;
  status?: string;
}
