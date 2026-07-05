export interface DocumentoTipoConfig {
  codigo: string;
  descricao: string;
  destino: string;
  exige_farmaceutico: number;
  template_codigo: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface DocumentoTipoConfigCreate {
  codigo?: string;
  descricao?: string;
  destino?: string;
  exige_farmaceutico?: number;
  template_codigo?: string;
  ativo?: number;
  criado_em?: string;
}

export interface DocumentoTipoConfigUpdate {
  codigo?: string;
  descricao?: string;
  destino?: string;
  exige_farmaceutico?: number;
  template_codigo?: string;
  ativo?: number;
  criado_em?: string;
}
