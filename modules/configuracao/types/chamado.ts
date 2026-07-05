export interface Chamado {
  id_chamado: number;
  id_unidade: number;
  id_sistema: number;
  area_responsavel: string;
  prioridade: string;
  status: string;
  titulo: string;
  descricao: string;
  id_usuario_abertura: number;
  id_usuario_atribuido: number;
  glpi_ticket_id: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface ChamadoCreate {
  area_responsavel?: string;
  status?: string;
  titulo?: string;
  descricao?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface ChamadoUpdate {
  area_responsavel?: string;
  status?: string;
  titulo?: string;
  descricao?: string;
  criado_em?: string;
  atualizado_em?: string;
}
