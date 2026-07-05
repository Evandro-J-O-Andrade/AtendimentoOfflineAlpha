export interface EstoqueSaldo {
  id_saldo: number;
  id_unidade: number;
  id_local: number;
  contexto_tipo: string;
  id_item: number;
  id_lote: number;
  qtd_fisica: number;
  qtd_reservada: number;
  qtd_projetada: number;
  id_sessao_usuario: number;
  id_entidade: number;
}

export interface EstoqueSaldoCreate {
  contexto_tipo?: string;
  qtd_fisica?: number;
  qtd_reservada?: number;
  qtd_projetada?: number;
}

export interface EstoqueSaldoUpdate {
  contexto_tipo?: string;
  qtd_fisica?: number;
  qtd_reservada?: number;
  qtd_projetada?: number;
}
