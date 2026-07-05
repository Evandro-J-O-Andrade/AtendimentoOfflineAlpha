export interface AtendimentoPreHospitalar {
  id_pre_hospitalar: number;
  id_atendimento: number;
  tipo_intervencao: string;
  descricao: string;
  inicio_em: string;
  fim_em: string;
  criado_em: string;
  id_entidade: number;
}

export interface AtendimentoPreHospitalarCreate {
  tipo_intervencao?: string;
  descricao?: string;
  inicio_em?: string;
  fim_em?: string;
  criado_em?: string;
}

export interface AtendimentoPreHospitalarUpdate {
  tipo_intervencao?: string;
  descricao?: string;
  inicio_em?: string;
  fim_em?: string;
  criado_em?: string;
}
