import "./ui.css";

interface BadgeProps {
  variant?: "success" | "muted";
  children: React.ReactNode;
}

/** Badge de status (ex.: ativo/inativo). */
export function Badge({ variant = "muted", children }: BadgeProps) {
  return (
    <span className={`pt-badge pt-badge--${variant}`}>
      <span className="pt-badge__dot" />
      {children}
    </span>
  );
}
