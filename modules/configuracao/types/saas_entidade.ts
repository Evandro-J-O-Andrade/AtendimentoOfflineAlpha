export interface SaasEntidade {
  id_entidade: number;
  nome_fantasia: string;
  razao_social: string;
  cnpj: string;
  tipo_entidade: string;
  criado_em: string;
  atualizado_em: string;
}

export interface SaasEntidadeCreate {
  nome_fantasia?: string;
  razao_social?: string;
  cnpj?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface SaasEntidadeUpdate {
  nome_fantasia?: string;
  razao_social?: string;
  cnpj?: string;
  criado_em?: string;
  atualizado_em?: string;
}
