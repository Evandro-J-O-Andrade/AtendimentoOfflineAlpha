export interface AssinaturaDigitalDocumentos {
  id: number;
  id_registro_clinico: number;
  tipo_documento: string;
  hash_assinatura: string;
  certificado_serial: string;
  data_assinatura: string;
  id_entidade: number;
}

export interface AssinaturaDigitalDocumentosCreate {
  tipo_documento?: string;
  hash_assinatura?: string;
  certificado_serial?: string;
  data_assinatura?: string;
}

export interface AssinaturaDigitalDocumentosUpdate {
  tipo_documento?: string;
  hash_assinatura?: string;
  certificado_serial?: string;
  data_assinatura?: string;
}
