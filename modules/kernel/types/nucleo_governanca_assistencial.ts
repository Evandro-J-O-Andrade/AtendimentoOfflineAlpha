export interface NucleoGovernancaAssistencial {
  id_nucleo: number;
  hash_nucleo_estrutura: string;
  versao_protocolo: number;
  descricao_release: string;
  estado_nucleo: string;
  criado_em: string;
  id_entidade: number;
}

export interface NucleoGovernancaAssistencialCreate {
  hash_nucleo_estrutura?: string;
  versao_protocolo?: number;
  descricao_release?: string;
  estado_nucleo?: string;
  criado_em?: string;
}

export interface NucleoGovernancaAssistencialUpdate {
  hash_nucleo_estrutura?: string;
  versao_protocolo?: number;
  descricao_release?: string;
  estado_nucleo?: string;
  criado_em?: string;
}
