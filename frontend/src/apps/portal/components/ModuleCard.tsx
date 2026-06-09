import { ArrowRight } from "lucide-react";
import { Badge } from "./ui/Badge";
import type { PortalModule } from "../types/portal";
import "./ModuleCard.css";

interface ModuleCardProps {
  module: PortalModule;
  onOpen: (module: PortalModule) => void;
}

/** Card de módulo do grid principal do Portal. */
export function ModuleCard({ module, onOpen }: ModuleCardProps) {
  const { name, description, icon: Icon, enabled, accent = "blue" } = module;

  return (
    <button
      type="button"
      className="pt-module-card"
      data-accent={accent}
      data-disabled={!enabled}
      disabled={!enabled}
      onClick={() => enabled && onOpen(module)}
      aria-label={`Abrir módulo ${name}`}
    >
      <div className="pt-module-card__top">
        <span className="pt-module-card__icon">
          <Icon size={24} strokeWidth={2} />
        </span>
        <Badge variant={enabled ? "success" : "muted"}>
          {enabled ? "Ativo" : "Inativo"}
        </Badge>
      </div>

      <div className="pt-module-card__body">
        <h3 className="pt-module-card__title">{name}</h3>
        <p className="pt-module-card__desc">{description}</p>
      </div>

      <div className="pt-module-card__footer">
        <span className="pt-module-card__cta">
          Acessar <ArrowRight size={16} />
        </span>
      </div>
    </button>
  );
}
