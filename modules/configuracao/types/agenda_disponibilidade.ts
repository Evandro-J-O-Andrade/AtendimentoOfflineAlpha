export interface AgendaDisponibilidade {
  id_disponibilidade: number;
  id_sistema: number;
  id_unidade: number;
  id_profissional: number;
  id_local_operacional: number;
  tipo: string;
  inicio_em: string;
  fim_em: string;
  recorrente: number;
  ativo: number;
  criado_em: string;
  id_usuario_criador: number;
  id_sessao_usuario: number;
  id_entidade: number;
}

export interface AgendaDisponibilidadeCreate {
  tipo?: string;
  inicio_em?: string;
  fim_em?: string;
  recorrente?: number;
  ativo?: number;
  criado_em?: string;
}

export interface AgendaDisponibilidadeUpdate {
  tipo?: string;
  inicio_em?: string;
  fim_em?: string;
  recorrente?: number;
  ativo?: number;
  criado_em?: string;
}
