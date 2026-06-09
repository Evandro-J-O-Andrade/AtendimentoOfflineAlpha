import { ModuleCard } from "./ModuleCard";
import type { PortalModule } from "../types/portal";
import "./ModuleGrid.css";

interface ModuleGridProps {
  modules: PortalModule[];
  onOpen: (module: PortalModule) => void;
}

/** Grid responsivo de cards de módulos. */
export function ModuleGrid({ modules, onOpen }: ModuleGridProps) {
  if (modules.length === 0) {
    return (
      <div className="pt-module-grid__empty">
        <p>Nenhum módulo disponível para o seu perfil.</p>
      </div>
    );
  }

  return (
    <div className="pt-module-grid">
      {modules.map((module) => (
        <ModuleCard key={module.id} module={module} onOpen={onOpen} />
      ))}
    </div>
  );
}
