export interface AssistencialCircuitBreaker {
  id_circuit: number;
  componente: string;
  estado: string;
  falhas_consecutivas: number;
  limite_falha: number;
  atualizado_em: string;
  id_entidade: number;
}

export interface AssistencialCircuitBreakerCreate {
  componente?: string;
  estado?: string;
  falhas_consecutivas?: number;
  limite_falha?: number;
  atualizado_em?: string;
}

export interface AssistencialCircuitBreakerUpdate {
  componente?: string;
  estado?: string;
  falhas_consecutivas?: number;
  limite_falha?: number;
  atualizado_em?: string;
}
