export interface AssistencialTelemetriaRuntime {
  id_telemetria: number;
  componente: string;
  metrica: string;
  valor: number;
  unidade: string;
  criticidade: string;
  criado_em: string;
  id_atendimento: number;
  id_entidade: number;
}

export interface AssistencialTelemetriaRuntimeCreate {
  componente?: string;
  metrica?: string;
  valor?: number;
  criado_em?: string;
}

export interface AssistencialTelemetriaRuntimeUpdate {
  componente?: string;
  metrica?: string;
  valor?: number;
  criado_em?: string;
}
