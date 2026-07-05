export interface FarmAtendimentoExterno {
  id_atendimento_ext: number;
  id_gpat: number;
  origem: string;
  nome_paciente: string;
  nome_medico: string;
  conselho_medico: string;
  numero_conselho: string;
  uf_conselho: string;
  data_receita: string;
  dias_tratamento: number;
  status: string;
  criado_em: string;
  atualizado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface FarmAtendimentoExternoCreate {
  origem?: string;
  nome_paciente?: string;
  nome_medico?: string;
  conselho_medico?: string;
  numero_conselho?: string;
  uf_conselho?: string;
  data_receita?: string;
  dias_tratamento?: number;
  status?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface FarmAtendimentoExternoUpdate {
  origem?: string;
  nome_paciente?: string;
  nome_medico?: string;
  conselho_medico?: string;
  numero_conselho?: string;
  uf_conselho?: string;
  data_receita?: string;
  dias_tratamento?: number;
  status?: string;
  criado_em?: string;
  atualizado_em?: string;
}
