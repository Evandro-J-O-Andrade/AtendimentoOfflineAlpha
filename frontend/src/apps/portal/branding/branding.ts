/**
 * Branding configurável (multiempresa / white-label).
 *
 * O produto é genérico — desenvolvido pela New Wave Sistemas Digitais — e
 * qualquer cliente pode sobrepor a identidade visual padrão. Nenhum conceito
 * de segmento (saúde, indústria, etc.) faz parte desta configuração.
 */
export interface Branding {
  /** Nome da plataforma (ex.: "Portal Corporativo"). */
  platformName: string;
  /** Nome da organização/cliente exibido no cabeçalho. */
  organizationName: string;
  /** Caminho do logo exibido no cabeçalho. */
  logoUrl: string;
  /** Cor primária da marca (token de tema). */
  primaryColor: string;
  /** Empresa desenvolvedora (rodapé / créditos). */
  vendorName: string;
}

/** Identidade visual padrão da plataforma. */
export const defaultBranding: Branding = {
  platformName: "Portal Corporativo",
  organizationName: "New Wave Sistemas Digitais",
  logoUrl: "/assets/img/sistema.png",
  primaryColor: "#2563eb",
  vendorName: "New Wave Sistemas Digitais",
};

/**
 * Resolve o branding efetivo, sobrepondo a marca do cliente (quando informada)
 * sobre a identidade padrão da plataforma.
 */
export function resolveBranding(clientBranding?: Partial<Branding>): Branding {
  return { ...defaultBranding, ...(clientBranding ?? {}) };
}
