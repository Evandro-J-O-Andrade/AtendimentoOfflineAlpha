export interface ProfissionalRegistro {
  id_profissional_registro: number;
  id_funcionario: number;
  tipo_conselho: string;
  numero_registro: string;
  uf_registro: string;
  data_emissao: string;
  data_validade: string;
  ativo: number;
  criado_em: string;
  id_entidade: number;
}

export interface ProfissionalRegistroCreate {
  tipo_conselho?: string;
  numero_registro?: string;
  uf_registro?: string;
  data_emissao?: string;
  ativo?: number;
  criado_em?: string;
}

export interface ProfissionalRegistroUpdate {
  tipo_conselho?: string;
  numero_registro?: string;
  uf_registro?: string;
  data_emissao?: string;
  ativo?: number;
  criado_em?: string;
}
