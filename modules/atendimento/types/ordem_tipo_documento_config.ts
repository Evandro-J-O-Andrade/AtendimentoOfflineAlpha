export interface OrdemTipoDocumentoConfig {
  tipo_ordem: string;
  tipo_documento: string;
  somente_controlado: number;
  somente_nao_controlado: number;
  ativo: number;
  id_entidade: number;
}

export interface OrdemTipoDocumentoConfigCreate {
  tipo_ordem?: string;
  tipo_documento?: string;
  somente_controlado?: number;
  somente_nao_controlado?: number;
  ativo?: number;
}

export interface OrdemTipoDocumentoConfigUpdate {
  tipo_ordem?: string;
  tipo_documento?: string;
  somente_controlado?: number;
  somente_nao_controlado?: number;
  ativo?: number;
}
