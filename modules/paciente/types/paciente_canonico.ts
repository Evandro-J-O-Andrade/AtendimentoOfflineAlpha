export interface PacienteCanonico {
  id_paciente: number;
  uuid_paciente: string;
  hash_identidade: string;
  nome: string;
  data_nascimento: string;
  sexo: string;
  documento_principal: string;
  metadata_identidade: Record<string, unknown>;
  estado_paciente: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PacienteCanonicoCreate {
  nome?: string;
  data_nascimento?: string;
  sexo?: string;
  documento_principal?: string;
  estado_paciente?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PacienteCanonicoUpdate {
  nome?: string;
  data_nascimento?: string;
  sexo?: string;
  documento_principal?: string;
  estado_paciente?: string;
  criado_em?: string;
  atualizado_em?: string;
}
