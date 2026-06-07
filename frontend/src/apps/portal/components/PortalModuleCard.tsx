import {
  ArrowRight,
  BarChart3,
  Boxes,
  CheckCircle2,
  CircleDashed,
  ClipboardList,
  Files,
  GraduationCap,
  LifeBuoy,
  LucideIcon,
  MapPinned,
  Newspaper,
  Pill,
  Warehouse,
} from "lucide-react";
import type { PortalModule } from "../types";

const iconMap: Record<string, LucideIcon> = {
  BarChart3,
  Boxes,
  ClipboardList,
  Files,
  GraduationCap,
  LifeBuoy,
  Newspaper,
  Pill,
  Warehouse,
};

interface PortalModuleCardProps {
  module: PortalModule;
  onOpen: (module: PortalModule) => void;
}

export function PortalModuleCard({ module, onOpen }: PortalModuleCardProps) {
  const Icon = iconMap[module.icon] || Boxes;
  const StatusIcon = module.active ? CheckCircle2 : CircleDashed;

  return (
    <article className={`portal-module-card portal-accent-${module.accent}`}>
      <div className="portal-module-card-top">
        <span className="portal-module-icon" aria-hidden="true">
          <Icon size={26} />
        </span>
        <span className={`portal-status ${module.active ? "active" : "inactive"}`}>
          <StatusIcon size={14} />
          {module.active ? "Ativo" : "Inativo"}
        </span>
      </div>

      <div className="portal-module-copy">
        <h2>{module.name}</h2>
        <p>{module.description}</p>
      </div>

      <div className="portal-module-footer">
        {module.requiresContext && (
          <span className="portal-context-flag">
            <MapPinned size={14} />
            Contexto
          </span>
        )}

        <button type="button" className="portal-module-action" onClick={() => onOpen(module)}>
          <span>{module.active ? "Abrir" : "Visualizar"}</span>
          <ArrowRight size={16} />
        </button>
      </div>
    </article>
  );
}
