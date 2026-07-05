export interface Medico {
  id_usuario: number;
  crm: string;
  uf_crm: string;
  id_especialidade: number;
  ativo: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface MedicoCreate {
  crm?: string;
  uf_crm?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface MedicoUpdate {
  crm?: string;
  uf_crm?: string;
  ativo?: number;
  criado_em?: string;
  atualizado_em?: string;
}
