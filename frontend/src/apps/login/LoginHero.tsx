import {
  ChartColumn,
  ChartPie,
  FileText,
  MessageSquare,
  ShieldCheck,
  Users,
} from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { SvgBackground } from "./SvgBackground";
import { NwLogo } from "./NwLogo";

const features: { icon: LucideIcon; label: string }[] = [
  { icon: ChartColumn, label: "Analytics" },
  { icon: Users, label: "Usuários" },
  { icon: FileText, label: "Documentos" },
  { icon: MessageSquare, label: "Comunicação" },
  { icon: ShieldCheck, label: "Segurança" },
  { icon: ChartPie, label: "Dashboard" },
];

/** Coluna ilustrativa (esquerda) da tela de login. */
export function LoginHero() {
  return (
    <section className="relative isolate flex min-h-[280px] items-center justify-center overflow-hidden lg:min-h-full">
      <SvgBackground />

      <div className="relative z-10 flex flex-col items-center px-8 py-12 text-center">
        <div className="nw-anim-float drop-shadow-[0_8px_24px_var(--glow-primary)]">
          <NwLogo size={120} gradientId="nw-hero-logo" />
        </div>

        <h1 className="mt-8 text-5xl font-bold leading-tight tracking-tight">
          <span className="text-[var(--text-strong)]">New Wave</span>
          <br />
          <span className="bg-gradient-to-r from-primary-bright to-secondary-bright bg-clip-text text-transparent">
            Enterprise
          </span>
        </h1>

        <p className="mt-5 max-w-sm text-base leading-relaxed text-[var(--text-muted)]">
          Plataforma SaaS Corporativa de Gestão e Inteligência Analítica
        </p>

        <div className="mt-10 flex flex-wrap items-center justify-center gap-6">
          {features.map(({ icon: Icon, label }) => (
            <div
              key={label}
              className="flex flex-col items-center gap-2 text-[var(--text-muted)]"
              title={label}
            >
              <span className="flex h-11 w-11 items-center justify-center rounded-xl border border-[var(--surface-border)] bg-[var(--surface)] backdrop-blur-md">
                <Icon size={20} strokeWidth={1.75} />
              </span>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
