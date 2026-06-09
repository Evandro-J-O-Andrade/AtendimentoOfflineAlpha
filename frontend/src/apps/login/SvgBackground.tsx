/**
 * SvgBackground — ilustração 100% vetorial (SVG) para a coluna esquerda.
 * Contém grid tecnológico, ondas, feixes luminosos, círculos translúcidos,
 * partículas e glow azul/violeta. Sem imagens externas.
 *
 * Todas as cores derivam dos tokens white-label (var(--primary), etc.).
 */
export function SvgBackground() {
  return (
    <svg
      className="absolute inset-0 h-full w-full"
      viewBox="0 0 600 800"
      preserveAspectRatio="xMidYMid slice"
      aria-hidden="true"
      focusable="false"
    >
      <defs>
        <linearGradient id="nw-bg-grad" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" style={{ stopColor: "var(--bg-base)" }} />
          <stop offset="50%" style={{ stopColor: "var(--bg-elev)" }} />
          <stop offset="100%" style={{ stopColor: "var(--bg-base)" }} />
        </linearGradient>

        <linearGradient id="nw-line-grad" x1="0" y1="0" x2="1" y2="0">
          <stop offset="0%" style={{ stopColor: "var(--primary-bright)", stopOpacity: 0 }} />
          <stop offset="50%" style={{ stopColor: "var(--primary-bright)", stopOpacity: 0.9 }} />
          <stop offset="100%" style={{ stopColor: "var(--secondary-bright)", stopOpacity: 0 }} />
        </linearGradient>

        <linearGradient id="nw-line-grad-2" x1="0" y1="0" x2="1" y2="0">
          <stop offset="0%" style={{ stopColor: "var(--secondary)", stopOpacity: 0 }} />
          <stop offset="50%" style={{ stopColor: "var(--accent)", stopOpacity: 0.8 }} />
          <stop offset="100%" style={{ stopColor: "var(--secondary)", stopOpacity: 0 }} />
        </linearGradient>

        <radialGradient id="nw-glow-primary" cx="50%" cy="50%" r="50%">
          <stop offset="0%" style={{ stopColor: "var(--glow-primary)" }} />
          <stop offset="100%" style={{ stopColor: "var(--glow-primary)", stopOpacity: 0 }} />
        </radialGradient>

        <radialGradient id="nw-glow-secondary" cx="50%" cy="50%" r="50%">
          <stop offset="0%" style={{ stopColor: "var(--glow-secondary)" }} />
          <stop offset="100%" style={{ stopColor: "var(--glow-secondary)", stopOpacity: 0 }} />
        </radialGradient>

        <linearGradient id="nw-beam" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" style={{ stopColor: "var(--primary-bright)", stopOpacity: 0 }} />
          <stop offset="50%" style={{ stopColor: "var(--primary-bright)", stopOpacity: 0.25 }} />
          <stop offset="100%" style={{ stopColor: "var(--secondary-bright)", stopOpacity: 0 }} />
        </linearGradient>

        <pattern id="nw-grid" width="40" height="40" patternUnits="userSpaceOnUse">
          <path
            d="M 40 0 L 0 0 0 40"
            fill="none"
            stroke="var(--primary-bright)"
            strokeOpacity="0.07"
            strokeWidth="1"
          />
        </pattern>
      </defs>

      {/* Base gradient */}
      <rect width="600" height="800" fill="url(#nw-bg-grad)" />

      {/* Grid tecnológico */}
      <rect width="600" height="800" fill="url(#nw-grid)" />

      {/* Glows */}
      <circle cx="160" cy="220" r="260" fill="url(#nw-glow-primary)" className="nw-anim-pulse" />
      <circle cx="470" cy="560" r="240" fill="url(#nw-glow-secondary)" className="nw-anim-pulse" style={{ animationDelay: "2s" }} />

      {/* Feixes luminosos */}
      <g opacity="0.6">
        <polygon points="120,-40 220,-40 120,860 20,860" fill="url(#nw-beam)" className="nw-anim-drift" />
        <polygon points="380,-40 460,-40 360,860 280,860" fill="url(#nw-beam)" className="nw-anim-drift" style={{ animationDelay: "3s" }} />
      </g>

      {/* Círculos translúcidos rotativos */}
      <g className="nw-anim-spin" style={{ transformOrigin: "300px 400px" }}>
        <circle cx="300" cy="400" r="300" fill="none" stroke="var(--primary-bright)" strokeOpacity="0.10" strokeWidth="1" />
        <circle cx="300" cy="400" r="220" fill="none" stroke="var(--secondary-bright)" strokeOpacity="0.10" strokeWidth="1" strokeDasharray="6 10" />
        <circle cx="300" cy="400" r="140" fill="none" stroke="var(--accent)" strokeOpacity="0.10" strokeWidth="1" />
      </g>

      {/* Ondas vetoriais futuristas */}
      <g fill="none" strokeWidth="2">
        <path d="M -20 640 C 140 560, 260 760, 420 660 S 700 600, 660 720" stroke="url(#nw-line-grad)" className="nw-anim-float" />
        <path d="M -20 690 C 160 600, 280 800, 440 700 S 720 640, 660 760" stroke="url(#nw-line-grad-2)" opacity="0.8" className="nw-anim-float" style={{ animationDelay: "1.5s" }} />
        <path d="M -20 600 C 120 540, 300 700, 460 600 S 700 560, 680 660" stroke="url(#nw-line-grad)" opacity="0.5" className="nw-anim-float" style={{ animationDelay: "3s" }} />
      </g>

      {/* Partículas suaves */}
      <g fill="var(--primary-bright)">
        <circle cx="90" cy="140" r="2.5" className="nw-anim-pulse" />
        <circle cx="500" cy="120" r="2" className="nw-anim-pulse" style={{ animationDelay: "1s" }} />
        <circle cx="420" cy="300" r="3" className="nw-anim-pulse" style={{ animationDelay: "2s" }} />
        <circle cx="180" cy="360" r="2" className="nw-anim-pulse" style={{ animationDelay: "0.5s" }} />
        <circle cx="540" cy="430" r="2.5" className="nw-anim-pulse" style={{ animationDelay: "2.5s" }} />
        <circle cx="80" cy="480" r="2" className="nw-anim-pulse" style={{ animationDelay: "1.8s" }} />
      </g>
      <g fill="var(--secondary-bright)">
        <circle cx="260" cy="180" r="2" className="nw-anim-pulse" style={{ animationDelay: "1.2s" }} />
        <circle cx="350" cy="500" r="2.5" className="nw-anim-pulse" style={{ animationDelay: "0.8s" }} />
        <circle cx="150" cy="560" r="2" className="nw-anim-pulse" style={{ animationDelay: "2.2s" }} />
      </g>
    </svg>
  );
}
