export interface RhRegistroProfissional {
  id_registro: number;
  id_pessoa: number;
  conselho: string;
  numero: string;
  uf: string;
  uf_norm: string;
  especialidade: string;
  validade: string;
  status: string;
  origem: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface RhRegistroProfissionalCreate {
  conselho?: string;
  numero?: string;
  uf?: string;
  uf_norm?: string;
  status?: string;
  origem?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface RhRegistroProfissionalUpdate {
  conselho?: string;
  numero?: string;
  uf?: string;
  uf_norm?: string;
  status?: string;
  origem?: string;
  criado_em?: string;
  atualizado_em?: string;
}
