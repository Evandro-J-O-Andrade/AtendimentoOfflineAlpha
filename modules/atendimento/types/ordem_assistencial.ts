export interface OrdemAssistencial {
  id: number;
  id_ffa: number;
  tipo_ordem: string;
  status: string;
  origem: string;
  payload_clinico: Record<string, unknown>;
  prioridade: number;
  iniciado_em: string;
  suspenso_em: string;
  encerrado_em: string;
  motivo_suspensao: string;
  motivo_encerramento: string;
  criado_em: string;
  criado_por: number;
  atualizado_em: string;
  atualizado_por: number;
  id_atendimento: number;
  id_entidade: number;
}

export interface OrdemAssistencialCreate {
  tipo_ordem?: string;
  status?: string;
  origem?: string;
  payload_clinico?: Record<string, unknown>;
  iniciado_em?: string;
  suspenso_em?: string;
  encerrado_em?: string;
  motivo_suspensao?: string;
  motivo_encerramento?: string;
  criado_em?: string;
  criado_por?: number;
  atualizado_em?: string;
  atualizado_por?: number;
}

export interface OrdemAssistencialUpdate {
  tipo_ordem?: string;
  status?: string;
  origem?: string;
  payload_clinico?: Record<string, unknown>;
  iniciado_em?: string;
  suspenso_em?: string;
  encerrado_em?: string;
  motivo_suspensao?: string;
  motivo_encerramento?: string;
  criado_em?: string;
  criado_por?: number;
  atualizado_em?: string;
  atualizado_por?: number;
}
