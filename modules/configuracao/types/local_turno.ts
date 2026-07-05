export interface LocalTurno {
  id_local_turno: number;
  id_local: number;
  turno: string;
  id_entidade: number;
}

export interface LocalTurnoCreate {
  turno?: string;
}

export interface LocalTurnoUpdate {
  turno?: string;
}
