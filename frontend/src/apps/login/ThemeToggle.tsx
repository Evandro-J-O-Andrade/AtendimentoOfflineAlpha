import { Moon, Sun } from "lucide-react";

export type LoginTheme = "dark" | "light";

interface ThemeToggleProps {
  theme: LoginTheme;
  onToggle: () => void;
}

/** Alterna entre tema escuro e claro da tela de login. */
export function ThemeToggle({ theme, onToggle }: ThemeToggleProps) {
  const isDark = theme === "dark";
  return (
    <button
      type="button"
      onClick={onToggle}
      aria-pressed={isDark}
      className="flex items-center gap-2 rounded-full border border-[var(--surface-border)] bg-[var(--surface)] px-3 py-1.5 text-sm text-[var(--text-muted)] backdrop-blur-md transition-colors hover:text-[var(--text-strong)]"
    >
      {isDark ? <Moon size={16} /> : <Sun size={16} />}
      <span>{isDark ? "Modo escuro" : "Modo claro"}</span>
    </button>
  );
}
