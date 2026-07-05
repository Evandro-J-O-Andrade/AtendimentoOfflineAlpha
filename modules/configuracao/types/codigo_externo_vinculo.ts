export interface CodigoExternoVinculo {
  id_vinculo: number;
  tipo: string;
  sistema_externo: string;
  codigo_externo: string;
  id_codigo_universal: number;
  id_sessao_usuario: number;
  observacao: string;
  criado_em: string;
  id_entidade: number;
}

export interface CodigoExternoVinculoCreate {
  tipo?: string;
  sistema_externo?: string;
  codigo_externo?: string;
  observacao?: string;
  criado_em?: string;
}

export interface CodigoExternoVinculoUpdate {
  tipo?: string;
  sistema_externo?: string;
  codigo_externo?: string;
  observacao?: string;
  criado_em?: string;
}
