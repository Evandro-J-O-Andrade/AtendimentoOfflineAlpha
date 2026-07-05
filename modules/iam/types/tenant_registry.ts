export interface TenantRegistry {
  id_tenant: number;
  uuid_tenant: string;
  nome_fantasia: string;
  razao_social: string;
  cnpj: string;
  cnes: string;
  instancia_primary: number;
  regiao: string;
  pais: string;
  status: string;
  created_at: string;
  updated_at: string;
  id_entidade: number;
}

export interface TenantRegistryCreate {
  nome_fantasia?: string;
  razao_social?: string;
  cnpj?: string;
  cnes?: string;
  instancia_primary?: number;
  regiao?: string;
  pais?: string;
  status?: string;
  created_at?: string;
  updated_at?: string;
}

export interface TenantRegistryUpdate {
  nome_fantasia?: string;
  razao_social?: string;
  cnpj?: string;
  cnes?: string;
  instancia_primary?: number;
  regiao?: string;
  pais?: string;
  status?: string;
  created_at?: string;
  updated_at?: string;
}
