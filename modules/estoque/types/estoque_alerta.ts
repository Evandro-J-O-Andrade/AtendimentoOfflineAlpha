export interface EstoqueAlerta {
  id_alerta: number;
  id_saldo: number;
  tipo_alerta: string;
  gerado_em: string;
  resolvido: number;
  id_entidade: number;
}

export interface EstoqueAlertaCreate {
  tipo_alerta?: string;
  gerado_em?: string;
}

export interface EstoqueAlertaUpdate {
  tipo_alerta?: string;
  gerado_em?: string;
}
