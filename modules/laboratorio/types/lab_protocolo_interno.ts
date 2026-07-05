export interface LabProtocoloInterno {
  id: number;
  id_ffa: number;
  codigo_amostra: string;
  tipo_material: string;
  status_laboratorial: string;
  impresso: number;
  id_entidade: number;
}

export interface LabProtocoloInternoCreate {
  codigo_amostra?: string;
  tipo_material?: string;
  status_laboratorial?: string;
  impresso?: number;
}

export interface LabProtocoloInternoUpdate {
  codigo_amostra?: string;
  tipo_material?: string;
  status_laboratorial?: string;
  impresso?: number;
}
