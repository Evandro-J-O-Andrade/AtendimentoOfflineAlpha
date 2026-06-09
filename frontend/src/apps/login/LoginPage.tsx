import { useState } from "react";
import { CloudCheck, Lock, ShieldCheck } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { LoginHero } from "./LoginHero";
import { LoginForm } from "./LoginForm";
import { ThemeToggle, type LoginTheme } from "./ThemeToggle";
import { Footer } from "./Footer";

const securityBadges: { icon: LucideIcon; title: string }[] = [
  { icon: ShieldCheck, title: "Segurança Avançada" },
  { icon: CloudCheck, title: "Alta Disponibilidade" },
  { icon: Lock, title: "Conformidade LGPD" },
];

/**
 * Tela de login premium do New Wave Enterprise.
 * Layout em duas colunas (hero ilustrativo + card glassmorphism).
 */
export default function LoginPage() {
  const [theme, setTheme] = useState<LoginTheme>("dark");

  return (
    <div
      className="nw-login flex min-h-screen flex-col bg-[var(--bg-base)] text-[var(--text-base)]"
      data-theme={theme}
    >
      <div className="grid flex-1 grid-cols-1 lg:grid-cols-2">
        {/* Coluna esquerda — ilustração (vai para o topo no mobile) */}
        <LoginHero />

        {/* Coluna direita — card glassmorphism */}
        <div className="relative flex items-center justify-center px-6 py-12 sm:px-10">
          <div className="w-full max-w-md rounded-3xl border border-[var(--surface-border)] bg-[var(--surface)] p-8 shadow-2xl backdrop-blur-xl sm:p-10">
            <div className="flex justify-end">
              <ThemeToggle
                theme={theme}
                onToggle={() =>
                  setTheme((t) => (t === "dark" ? "light" : "dark"))
                }
              />
            </div>

            <div className="mt-4">
              <h2 className="text-3xl font-bold leading-tight text-[var(--text-strong)]">
                Bem-vindo ao
                <br />
                New Wave{" "}
                <span className="bg-gradient-to-r from-primary-bright to-secondary-bright bg-clip-text text-transparent">
                  Enterprise
                </span>
              </h2>
              <p className="mt-3 text-[var(--text-muted)]">
                Acesse sua conta para continuar gerenciando sua empresa com
                eficiência e inteligência.
              </p>
            </div>

            <div className="mt-8">
              <LoginForm />
            </div>

            <div className="mt-8">
              <div className="flex items-center gap-3 text-xs text-[var(--text-muted)]">
                <span className="h-px flex-1 bg-[var(--surface-border)]" />
                Plataforma segura e confiável
                <span className="h-px flex-1 bg-[var(--surface-border)]" />
              </div>

              <div className="mt-5 grid grid-cols-3 gap-3">
                {securityBadges.map(({ icon: Icon, title }) => (
                  <div
                    key={title}
                    className="flex flex-col items-center gap-2 rounded-2xl border border-[var(--surface-border)] bg-[var(--surface)] px-2 py-3 text-center"
                  >
                    <Icon size={20} className="text-primary-bright" />
                    <span className="text-xs leading-tight text-[var(--text-muted)]">
                      {title}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>

      <Footer />
    </div>
  );
}
