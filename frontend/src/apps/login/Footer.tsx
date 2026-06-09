import { NwLogo } from "./NwLogo";

/** Rodapé global da tela de login. */
export function Footer() {
  return (
    <footer className="border-t border-[var(--surface-border)] px-6 py-5 text-sm text-[var(--text-muted)] lg:px-10">
      <div className="mx-auto flex max-w-7xl flex-col items-center gap-4 text-center md:flex-row md:justify-between md:text-left">
        <div className="flex items-center gap-3">
          <NwLogo size={28} gradientId="nw-footer-logo" />
          <span className="font-semibold text-[var(--text-base)]">
            New Wave Enterprise
          </span>
          <span className="hidden text-[var(--text-muted)] md:inline">|</span>
          <span>v1.0.0</span>
        </div>

        <div>
          © 2026 New Wave Sistemas Digitais. Todos os direitos reservados.
        </div>

        <div className="leading-relaxed">
          <div>
            Desenvolvido por{" "}
            <span className="font-semibold text-[var(--text-base)]">
              New Wave Sistemas Digitais
            </span>
          </div>
          <div>
            Fundador e CEO:{" "}
            <span className="font-medium text-primary-bright">
              Evandro Andrade
            </span>
          </div>
        </div>
      </div>
    </footer>
  );
}
