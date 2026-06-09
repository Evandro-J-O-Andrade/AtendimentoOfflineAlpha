import "./ui.css";

type CardProps = React.HTMLAttributes<HTMLDivElement>;

/** Container de superfície reutilizável do design system. */
export function Card({ className = "", children, ...rest }: CardProps) {
  return (
    <div className={`pt-card ${className}`.trim()} {...rest}>
      {children}
    </div>
  );
}
