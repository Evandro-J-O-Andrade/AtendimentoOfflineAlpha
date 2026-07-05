export interface EstoqueSaldoMaster {
  id_saldo: number;
  id_unidade: number;
  id_local: number;
  id_item: number;
  id_lote: number;
  qtd_fisica: number;
  qtd_reservada: number;
  qtd_projetada: number;
  id_sessao_usuario: number;
  id_entidade: number;
}

export interface EstoqueSaldoMasterCreate {
  qtd_fisica?: number;
  qtd_reservada?: number;
  qtd_projetada?: number;
}

export interface EstoqueSaldoMasterUpdate {
  qtd_fisica?: number;
  qtd_reservada?: number;
  qtd_projetada?: number;
}
