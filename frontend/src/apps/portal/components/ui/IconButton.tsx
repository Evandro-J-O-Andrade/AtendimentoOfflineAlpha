import "./ui.css";

interface IconButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  /** Texto acessível do botão. */
  label: string;
  /** Quantidade exibida no badge (ex.: notificações não lidas). */
  badgeCount?: number;
}

/** Botão de ícone reutilizável (cabeçalho do portal). */
export function IconButton({
  label,
  badgeCount,
  children,
  className = "",
  ...rest
}: IconButtonProps) {
  return (
    <button
      type="button"
      className={`pt-icon-button ${className}`.trim()}
      aria-label={label}
      title={label}
      {...rest}
    >
      {children}
      {badgeCount && badgeCount > 0 ? (
        <span className="pt-icon-button__badge">
          {badgeCount > 9 ? "9+" : badgeCount}
        </span>
      ) : null}
    </button>
  );
}
