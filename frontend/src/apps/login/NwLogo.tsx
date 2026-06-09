interface NwLogoProps {
  size?: number;
  className?: string;
  /** id único para o gradiente (evita colisão quando há vários logos). */
  gradientId?: string;
}

/**
 * Marca "NW" (New Wave) — vetorial, com gradiente azul → violeta.
 * Forma de onda ascendente que remete ao nome New Wave.
 */
export function NwLogo({
  size = 48,
  className = "",
  gradientId = "nw-logo-grad",
}: NwLogoProps) {
  return (
    <svg
      width={size}
      height={(size * 3) / 4}
      viewBox="0 0 64 48"
      fill="none"
      className={className}
      aria-hidden="true"
      focusable="false"
    >
      <defs>
        <linearGradient id={gradientId} x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" style={{ stopColor: "var(--primary-bright)" }} />
          <stop offset="55%" style={{ stopColor: "var(--primary)" }} />
          <stop offset="100%" style={{ stopColor: "var(--secondary-bright)" }} />
        </linearGradient>
      </defs>
      <path
        d="M5 42 L20 8 L32 30 L44 8 L59 42"
        stroke={`url(#${gradientId})`}
        strokeWidth="7"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M32 30 L32 30"
        stroke={`url(#${gradientId})`}
        strokeWidth="7"
        strokeLinecap="round"
      />
    </svg>
  );
}
