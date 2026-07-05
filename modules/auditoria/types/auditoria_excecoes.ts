export interface AuditoriaExcecoes {
  id: number;
  id_ffa: number;
  id_paciente: number;
  motivo: string;
  chamado_por: string;
  criado_em: string;
  id_entidade: number;
}

export interface AuditoriaExcecoesCreate {
  motivo?: string;
  chamado_por?: string;
  criado_em?: string;
}

export interface AuditoriaExcecoesUpdate {
  motivo?: string;
  chamado_por?: string;
  criado_em?: string;
}
