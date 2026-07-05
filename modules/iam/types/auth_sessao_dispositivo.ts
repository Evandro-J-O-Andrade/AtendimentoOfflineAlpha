export interface AuthSessaoDispositivo {
  id_dispositivo_confiavel: number;
  id_usuario: number;
  dispositivo_hash: string;
  nome_dispositivo: string;
  sistema_operacional: string;
  navegador: string;
  ultimo_ip: string;
  ultimo_acesso: string;
  primeiro_acesso: string;
  confiavel: number;
  ativo: number;
  id_entidade: number;
}

export interface AuthSessaoDispositivoCreate {
  dispositivo_hash?: string;
  nome_dispositivo?: string;
  sistema_operacional?: string;
  navegador?: string;
  ultimo_ip?: string;
  ultimo_acesso?: string;
  primeiro_acesso?: string;
  confiavel?: number;
  ativo?: number;
}

export interface AuthSessaoDispositivoUpdate {
  dispositivo_hash?: string;
  nome_dispositivo?: string;
  sistema_operacional?: string;
  navegador?: string;
  ultimo_ip?: string;
  ultimo_acesso?: string;
  primeiro_acesso?: string;
  confiavel?: number;
  ativo?: number;
}
