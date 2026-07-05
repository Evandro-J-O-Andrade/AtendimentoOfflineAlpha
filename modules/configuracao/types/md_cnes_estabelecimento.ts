export interface MdCnesEstabelecimento {
  cnes: string;
  competencia: string;
  nome_fantasia: string;
  razao_social: string;
  cnpj: string;
  uf: string;
  municipio_ibge: string;
  logradouro: string;
  numero: string;
  bairro: string;
  cep: string;
  telefone: string;
  tipo_gestao: string;
  esfera_adm: string;
  ativo: number;
  atualizado_em: string;
  id_entidade: number;
}

export interface MdCnesEstabelecimentoCreate {
  cnes?: string;
  competencia?: string;
  nome_fantasia?: string;
  razao_social?: string;
  cnpj?: string;
  uf?: string;
  municipio_ibge?: string;
  logradouro?: string;
  numero?: string;
  bairro?: string;
  cep?: string;
  telefone?: string;
  tipo_gestao?: string;
  esfera_adm?: string;
  ativo?: number;
  atualizado_em?: string;
}

export interface MdCnesEstabelecimentoUpdate {
  cnes?: string;
  competencia?: string;
  nome_fantasia?: string;
  razao_social?: string;
  cnpj?: string;
  uf?: string;
  municipio_ibge?: string;
  logradouro?: string;
  numero?: string;
  bairro?: string;
  cep?: string;
  telefone?: string;
  tipo_gestao?: string;
  esfera_adm?: string;
  ativo?: number;
  atualizado_em?: string;
}
