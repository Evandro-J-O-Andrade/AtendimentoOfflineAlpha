export interface AssistenciaSocialAtendimento {
  id_as: number;
  id_unidade: number;
  id_senha: number;
  id_ffa: number;
  status: string;
  motivo: string;
  relato: string;
  id_usuario_abertura: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface AssistenciaSocialAtendimentoCreate {
  status?: string;
  motivo?: string;
  relato?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface AssistenciaSocialAtendimentoUpdate {
  status?: string;
  motivo?: string;
  relato?: string;
  criado_em?: string;
  atualizado_em?: string;
}
