import type { ReactNode } from "react";
import { Navigate } from "react-router-dom";
import { usePortalModules } from "../hooks/usePortalModules";

interface PortalModuleGateProps {
  moduleId: string;
  children: ReactNode;
}

export function PortalModuleGate({ moduleId, children }: PortalModuleGateProps) {
  const { modules, loading } = usePortalModules();

  if (loading) {
    return (
      <main className="portal-page">
        <div className="portal-loading">Carregando...</div>
      </main>
    );
  }

  const allowed = modules.some((module) => module.id === moduleId);

  if (!allowed) {
    return <Navigate to="/portal" replace />;
  }

  return <>{children}</>;
}
