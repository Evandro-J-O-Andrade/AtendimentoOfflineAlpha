export interface Runtime {
  id_saas_entidade: number | null;
  id_unidade: number | null;
  id_local_operacional: number | null;
  id_perfil: number | null;
  contexto_selecionado: boolean;
}

export interface RuntimeContextType {
  runtime: Runtime;
  setRuntime: (runtime: Partial<Runtime>) => void;
}

export interface TenantConfig {
  name: string;
  logo: string;
  primaryColor: string;
  theme: 'light' | 'dark';
}