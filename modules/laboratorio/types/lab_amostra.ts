export interface LabAmostra {
  id_amostra: number;
  id_protocolo: number;
  codigo_amostra: string;
  tipo_material: string;
  status: string;
  impresso: number;
  coletado_em: string;
  id_sessao_coleta: number;
  id_usuario_coleta: number;
  criado_em: string;
  atualizado_em: string;
  id_ffa: number;
  id_entidade: number;
}

export interface LabAmostraCreate {
  codigo_amostra?: string;
  tipo_material?: string;
  status?: string;
  impresso?: number;
  coletado_em?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface LabAmostraUpdate {
  codigo_amostra?: string;
  tipo_material?: string;
  status?: string;
  impresso?: number;
  coletado_em?: string;
  criado_em?: string;
  atualizado_em?: string;
}
