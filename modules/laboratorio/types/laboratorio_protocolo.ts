export interface LaboratorioProtocolo {
  id_laboratorio_protocolo: number;
  id_ffa: number;
  id_gpat: number;
  id_pedido_item: number;
  id_codigo_universal: number;
  codigo: string;
  barcode: string;
  status: string;
  sistema_externo: string;
  codigo_externo: string;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface LaboratorioProtocoloCreate {
  codigo?: string;
  barcode?: string;
  status?: string;
  sistema_externo?: string;
  codigo_externo?: string;
  criado_em?: string;
  atualizado_em?: string;
}

export interface LaboratorioProtocoloUpdate {
  codigo?: string;
  barcode?: string;
  status?: string;
  sistema_externo?: string;
  codigo_externo?: string;
  criado_em?: string;
  atualizado_em?: string;
}
