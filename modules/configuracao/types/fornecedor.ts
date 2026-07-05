export interface Fornecedor {
  id_fornecedor: number;
  razao_social: string;
  nome_fantasia: string;
  cnpj: string;
  contato: string;
  criado_em: string;
  id_entidade: number;
}

export interface FornecedorCreate {
  razao_social?: string;
  nome_fantasia?: string;
  cnpj?: string;
  contato?: string;
  criado_em?: string;
}

export interface FornecedorUpdate {
  razao_social?: string;
  nome_fantasia?: string;
  cnpj?: string;
  contato?: string;
  criado_em?: string;
}
