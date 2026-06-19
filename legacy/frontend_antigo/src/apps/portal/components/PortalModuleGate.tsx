import type { ReactNode } from "react";
import { Navigate, useLocation } from "react-router-dom";
import { usePortalModules } from "../hooks/usePortalModules";

interface PortalModuleGateProps {
  moduleId: string;
  children: ReactNode;
}

export function PortalModuleGate({ moduleId, children }: PortalModuleGateProps) {
  const { modules, loading } = usePortalModules();
  const location = useLocation();

  if (loading) {
    return (
      <main className="portal-page">
        <div className="portal-loading">Carregando...</div>
      </main>
    );
  }

  const module = modules.find((m) => m.id === moduleId);

  if (!module) {
    return <Navigate to="/portal" replace />;
  }

  const requiresContext = module.requiresContext;

  if (requiresContext) {
    return (
      <Navigate
        to="/contexto"
        state={{ from: { pathname: location.pathname } }}
        replace
      />
    );
  }

  return <>{children}</>;
}
