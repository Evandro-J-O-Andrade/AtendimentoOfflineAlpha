export interface RegFormularioSnapshot {
  id_snapshot: number;
  entidade_ref: string;
  id_ref: number;
  tipo_formulario: string;
  versao_layout: string;
  competencia: string;
  payload_json: Record<string, unknown>;
  payload_hash: string;
  id_sessao_usuario: number;
  id_usuario_criador: number;
  sigilo_nivel: string;
  criado_em: string;
  id_entidade: number;
}

export interface RegFormularioSnapshotCreate {
  tipo_formulario?: string;
  versao_layout?: string;
  competencia?: string;
  payload_json?: Record<string, unknown>;
  payload_hash?: string;
  sigilo_nivel?: string;
  criado_em?: string;
}

export interface RegFormularioSnapshotUpdate {
  tipo_formulario?: string;
  versao_layout?: string;
  competencia?: string;
  payload_json?: Record<string, unknown>;
  payload_hash?: string;
  sigilo_nivel?: string;
  criado_em?: string;
}
