export interface PedidoMedicoItem {
  id_pedido_item: number;
  id_pedido_medico: number;
  tipo_item: string;
  status: string;
  codigo_sigtap: string;
  competencia_sigtap: string;
  cid10_principal: string;
  cnes_executante: string;
  id_codigo_universal: number;
  sistema_externo: string;
  codigo_externo: string;
  descricao: string;
  observacao: string;
  exige_cat: number;
  exige_sinan: number;
  criado_em: string;
  atualizado_em: string;
  id_entidade: number;
}

export interface PedidoMedicoItemCreate {
  tipo_item?: string;
  status?: string;
  codigo_sigtap?: string;
  competencia_sigtap?: string;
  cnes_executante?: string;
  sistema_externo?: string;
  codigo_externo?: string;
  descricao?: string;
  observacao?: string;
  exige_cat?: number;
  exige_sinan?: number;
  criado_em?: string;
  atualizado_em?: string;
}

export interface PedidoMedicoItemUpdate {
  tipo_item?: string;
  status?: string;
  codigo_sigtap?: string;
  competencia_sigtap?: string;
  cnes_executante?: string;
  sistema_externo?: string;
  codigo_externo?: string;
  descricao?: string;
  observacao?: string;
  exige_cat?: number;
  exige_sinan?: number;
  criado_em?: string;
  atualizado_em?: string;
}
