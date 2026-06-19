import { useEffect, useState } from "react";
import { fetchPortalModules } from "../services/portalService";
import type { PortalModule } from "../types";

export function usePortalModules() {
  const [modules, setModules] = useState<PortalModule[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    let active = true;

    async function loadModules() {
      setLoading(true);
      setError("");

      try {
        const result = await fetchPortalModules();
        if (active) setModules(result);
      } catch (err) {
        console.error("Erro ao carregar módulos do portal:", err);
        if (active) {
          setModules([]);
          setError("Não foi possível carregar os módulos disponíveis.");
        }
      } finally {
        if (active) setLoading(false);
      }
    }

    loadModules();

    return () => {
      active = false;
    };
  }, []);

  return { modules, loading, error };
}
