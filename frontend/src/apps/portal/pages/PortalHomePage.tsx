import { useMemo } from "react";
import { RefreshCw } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { PortalModuleCard } from "../components/PortalModuleCard";
import { usePortalModules } from "../hooks/usePortalModules";
import { getPortalBranding } from "../services/branding";
import type { PortalModule } from "../types";

export default function PortalHomePage() {
  const navigate = useNavigate();
  const { modules, loading, error } = usePortalModules();
  const brand = getPortalBranding();

  const totals = useMemo(() => {
    return {
      active: modules.filter((module) => module.active).length,
      inactive: modules.filter((module) => !module.active).length,
    };
  }, [modules]);

  function openModule(module: PortalModule) {
    if (!module.path) return;
    navigate(module.path);
  }

  return (
    <main className="portal-page">
      <section className="portal-intro" aria-labelledby="portal-title">
        <div>
          <p className="portal-eyebrow">{brand.companyName}</p>
          <h1 id="portal-title">{brand.productName}</h1>
          <p className="portal-subtitle">Aplicações disponíveis para o seu usuário.</p>
        </div>

        <div className="portal-summary">
          <span>
            <strong>{totals.active}</strong>
            Ativos
          </span>
          <span>
            <strong>{totals.inactive}</strong>
            Inativos
          </span>
        </div>
      </section>

      {loading && <div className="portal-loading">Carregando módulos...</div>}

      {!loading && error && (
        <div className="portal-error">
          <RefreshCw size={18} />
          {error}
        </div>
      )}

      {!loading && !error && modules.length === 0 && (
        <div className="portal-empty">Nenhum módulo disponível para seu usuário.</div>
      )}

      {!loading && !error && modules.length > 0 && (
        <section className="portal-module-grid" aria-label="Módulos disponíveis">
          {modules.map((module) => (
            <PortalModuleCard key={module.id} module={module} onOpen={openModule} />
          ))}
        </section>
      )}
    </main>
  );
}
