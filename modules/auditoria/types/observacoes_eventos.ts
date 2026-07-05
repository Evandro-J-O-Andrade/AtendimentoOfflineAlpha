export interface ObservacoesEventos {
  id: number;
  entidade: string;
  id_entidade: number;
  contexto: string;
  tipo: string;
  texto: string;
  id_usuario: number;
  criado_em: string;
}

export interface ObservacoesEventosCreate {
  contexto?: string;
  tipo?: string;
  texto?: string;
  criado_em?: string;
}

export interface ObservacoesEventosUpdate {
  contexto?: string;
  tipo?: string;
  texto?: string;
  criado_em?: string;
}
