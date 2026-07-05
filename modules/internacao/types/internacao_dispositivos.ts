export interface InternacaoDispositivos {
  id_dispositivo: number;
  id_internacao: number;
  tipo: string;
  localizacao: string;
  data_insercao: string;
  prazo_troca_dias: number;
  data_prevista_troca: string;
  id_usuario_insercao: number;
  status: string;
  id_entidade: number;
}

export interface InternacaoDispositivosCreate {
  tipo?: string;
  localizacao?: string;
  data_insercao?: string;
  prazo_troca_dias?: number;
  data_prevista_troca?: string;
  status?: string;
}

export interface InternacaoDispositivosUpdate {
  tipo?: string;
  localizacao?: string;
  data_insercao?: string;
  prazo_troca_dias?: number;
  data_prevista_troca?: string;
  status?: string;
}
