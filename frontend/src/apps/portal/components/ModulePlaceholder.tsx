import { ArrowLeft } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { Card } from "./ui/Card";
import "./ModulePlaceholder.css";

export interface PlaceholderSection {
  title: string;
  description: string;
  icon: LucideIcon;
}

interface ModulePlaceholderProps {
  title: string;
  description: string;
  icon: LucideIcon;
  /** Selo opcional (ex.: "Em breve"). */
  badge?: string;
  sections?: PlaceholderSection[];
}

/**
 * Tela padrão de módulo reservado para implementação futura.
 * Apresenta as funcionalidades previstas de forma consistente.
 */
export function ModulePlaceholder({
  title,
  description,
  icon: Icon,
  badge = "Em breve",
  sections = [],
}: ModulePlaceholderProps) {
  const navigate = useNavigate();

  return (
    <div className="pt-placeholder">
      <button
        type="button"
        className="pt-placeholder__back"
        onClick={() => navigate("/portal")}
      >
        <ArrowLeft size={16} /> Voltar ao portal
      </button>

      <div className="pt-placeholder__hero">
        <span className="pt-placeholder__icon">
          <Icon size={28} />
        </span>
        <div>
          <div className="pt-placeholder__title-row">
            <h1 className="pt-placeholder__title">{title}</h1>
            <span className="pt-placeholder__badge">{badge}</span>
          </div>
          <p className="pt-placeholder__desc">{description}</p>
        </div>
      </div>

      {sections.length > 0 && (
        <div className="pt-placeholder__grid">
          {sections.map((section) => (
            <Card key={section.title} className="pt-placeholder__section">
              <span className="pt-placeholder__section-icon">
                <section.icon size={20} />
              </span>
              <h3 className="pt-placeholder__section-title">{section.title}</h3>
              <p className="pt-placeholder__section-desc">
                {section.description}
              </p>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
