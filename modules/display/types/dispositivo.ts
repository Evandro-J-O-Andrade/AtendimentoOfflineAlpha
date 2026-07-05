export interface Dispositivo {
  id_dispositivo: number;
  identificador: string;
  descricao: string;
  tipo: string;
  ip_registro: string;
  criado_em: string;
  id_entidade: number;
}

export interface DispositivoCreate {
  descricao?: string;
  tipo?: string;
  ip_registro?: string;
  criado_em?: string;
}

export interface DispositivoUpdate {
  descricao?: string;
  tipo?: string;
  ip_registro?: string;
  criado_em?: string;
}
