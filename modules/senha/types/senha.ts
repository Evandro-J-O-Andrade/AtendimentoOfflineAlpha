export interface Senha {
  id_senha: number;
  id_unidade: number;
  codigo_visual: string;
  id_paciente: number;
  origem_entrada: string;
  id_prioridade: number;
  id_fluxo_status: number;
  id_sessao_usuario: number;
  criado_em: string;
  atualizado_em: string;
  uuid_sync: string;
  versao_sync: number;
  hash_estado: string;
  id_ffa: number;
  id_entidade: number;
}

export interface SenhaCreate {
  codigo_visual?: string;
  origem_entrada?: string;
  criado_em?: string;
  atualizado_em?: string;
  versao_sync?: number;
  hash_estado?: string;
}

export interface SenhaUpdate {
  codigo_visual?: string;
  origem_entrada?: string;
  criado_em?: string;
  atualizado_em?: string;
  versao_sync?: number;
  hash_estado?: string;
}
