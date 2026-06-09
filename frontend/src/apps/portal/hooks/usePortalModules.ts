import { useEffect, useMemo, useState } from "react";
import { portalModules } from "../config/modules";
import { fetchPortalAccess } from "../services/portalService";
import type { PortalAccess, PortalModule } from "../types/portal";

interface UsePortalModulesResult {
  /** Módulos visíveis ao usuário (já filtrados por permissão). */
  modules: PortalModule[];
  loading: boolean;
  /** Indica que as permissões não puderam ser carregadas (modo fallback). */
  fallback: boolean;
}

/**
 * Filtra o catálogo de módulos pelas permissões do usuário.
 *
 * Regra de negócio: módulos sem permissão NÃO devem aparecer. Em modo
 * fallback (backend indisponível) todos os módulos ativos são exibidos.
 */
function filterByAccess(
  modules: PortalModule[],
  access: PortalAccess,
): PortalModule[] {
  if (access.fallback) {
    return modules;
  }
  return modules.filter((mod) => {
    if (!mod.permission) return true;
    return access.permissions.includes(mod.permission);
  });
}

export function usePortalModules(): UsePortalModulesResult {
  const [access, setAccess] = useState<PortalAccess | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;
    fetchPortalAccess()
      .then((result) => {
        if (active) setAccess(result);
      })
      .finally(() => {
        if (active) setLoading(false);
      });
    return () => {
      active = false;
    };
  }, []);

  const modules = useMemo(() => {
    const effectiveAccess: PortalAccess = access ?? {
      permissions: [],
      fallback: true,
    };
    return filterByAccess(portalModules, effectiveAccess);
  }, [access]);

  return { modules, loading, fallback: access?.fallback ?? true };
}
