export interface LabResultado {
  id_resultado: number;
  protocolo_interno: string;
  id_ffa: number;
  resultado_link: string;
  resultado_texto: string;
  critico: number;
  recebido_em: string;
  id_sessao_usuario: number;
  id_usuario: number;
  id_entidade: number;
}

export interface LabResultadoCreate {
  protocolo_interno?: string;
  resultado_link?: string;
  resultado_texto?: string;
  critico?: number;
}

export interface LabResultadoUpdate {
  protocolo_interno?: string;
  resultado_link?: string;
  resultado_texto?: string;
  critico?: number;
}
