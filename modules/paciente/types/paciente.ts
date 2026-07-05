export interface Paciente {
  id: number;
  uuid_paciente: string;
  hash_identidade: string;
  id_pessoa: number;
  prontuario: string;
  data_cadastro: string;
  sexo: string;
  data_nascimento: string;
  nome: string;
  documento_principal: string;
  metadata_identidade: Record<string, unknown>;
  id_entidade: number;
}

export interface PacienteCreate {
  prontuario?: string;
  data_cadastro?: string;
  sexo?: string;
  data_nascimento?: string;
  nome?: string;
  documento_principal?: string;
}

export interface PacienteUpdate {
  prontuario?: string;
  data_cadastro?: string;
  sexo?: string;
  data_nascimento?: string;
  nome?: string;
  documento_principal?: string;
}
