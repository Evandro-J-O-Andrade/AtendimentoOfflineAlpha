import type { LucideIcon } from "lucide-react";

/**
 * Tipo de módulo do Portal Corporativo.
 * - "operational": exige seleção de contexto operacional antes de entrar.
 * - "standalone": abre direto o dashboard do módulo (sem contexto).
 */
export type ModuleType = "operational" | "standalone";

/** Definição declarativa de um módulo exibido no Portal. */
export interface PortalModule {
  /** Identificador único do módulo. */
  id: string;
  /** Nome exibido no card. */
  name: string;
  /** Descrição curta exibida no card. */
  description: string;
  /** Ícone (lucide-react). */
  icon: LucideIcon;
  /** Classifica se o módulo precisa de contexto operacional. */
  type: ModuleType;
  /** Estado ativo/inativo do módulo (módulos inativos aparecem desabilitados). */
  enabled: boolean;
  /**
   * Código de permissão exigido. Quando definido e o usuário não possui a
   * permissão, o módulo NÃO é exibido no portal.
   */
  permission?: string;
  /** Rota de destino ao clicar no card. */
  route: string;
  /** Cor de destaque do card (token de tema). */
  accent?: ModuleAccent;
}

/** Paleta de destaque dos cards (mapeada para tokens CSS). */
export type ModuleAccent =
  | "blue"
  | "green"
  | "amber"
  | "violet"
  | "rose"
  | "cyan"
  | "slate"
  | "indigo";

/** Conjunto de permissões do usuário autenticado. */
export interface PortalAccess {
  /** Lista de códigos de permissão concedidos ao usuário. */
  permissions: string[];
  /**
   * Quando true, o portal não recebeu permissões do backend (ex.: modo
   * offline) e cai para o comportamento de exibir todos os módulos ativos.
   */
  fallback: boolean;
}
