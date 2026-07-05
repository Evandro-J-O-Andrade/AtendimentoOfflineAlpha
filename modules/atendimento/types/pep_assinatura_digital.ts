export interface PepAssinaturaDigital {
  id: number;
  id_atendimento: number;
  hash_conteudo: string;
  assinatura_base64: string;
  data_assinatura: string;
  id_entidade: number;
}

export interface PepAssinaturaDigitalCreate {
  hash_conteudo?: string;
  assinatura_base64?: string;
  data_assinatura?: string;
}

export interface PepAssinaturaDigitalUpdate {
  hash_conteudo?: string;
  assinatura_base64?: string;
  data_assinatura?: string;
}
