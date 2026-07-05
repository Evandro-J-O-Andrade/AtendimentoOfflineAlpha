export interface Remocao {
  id_remocao: number;
  id_unidade: number;
  id_senha: number;
  id_ffa: number;
  origem: string;
  destino: string;
  motivo: string;
  status: string;
  id_viatura: number;
  condutor_interno: string;
  condutor_externo: string;
  protocolo_cross: string;
  id_usuario_solicitante: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface RemocaoCreate {
  origem?: string;
  destino?: string;
  motivo?: string;
  status?: string;
  condutor_interno?: string;
  condutor_externo?: string;
  protocolo_cross?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface RemocaoUpdate {
  origem?: string;
  destino?: string;
  motivo?: string;
  status?: string;
  condutor_interno?: string;
  condutor_externo?: string;
  protocolo_cross?: string;
  criado_em?: string;
  atualizado_em?: string;
}
