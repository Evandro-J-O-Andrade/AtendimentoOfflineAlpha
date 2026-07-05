export interface AssinaturaDigitalProntuario {
  id: number;
  id_ffa_evolucao: number;
  hash_assinatura: string;
  certificado_serial: string;
  data_assinatura: string;
  id_usuario: number;
  id_entidade: number;
}

export interface AssinaturaDigitalProntuarioCreate {
  hash_assinatura?: string;
  certificado_serial?: string;
  data_assinatura?: string;
}

export interface AssinaturaDigitalProntuarioUpdate {
  hash_assinatura?: string;
  certificado_serial?: string;
  data_assinatura?: string;
}
