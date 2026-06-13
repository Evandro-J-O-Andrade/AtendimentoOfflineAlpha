export interface TenantBranding {
  id_entidade: number | null;
  productName: string;
  companyName: string;
  logoUrl: string | null;
  theme: {
    primary: string;
    secondary: string;
    accent: string;
  };
}

const DEFAULT_BRANDING: TenantBranding = {
  id_entidade: null,
  productName: 'New Wave Enterprise',
  companyName: 'New Wave Sistemas Digitais',
  logoUrl: null,
  theme: {
    primary: '#4f46e5', // indigo-600
    secondary: '#0ea5e9', // sky-500
    accent: '#f43f5e', // rose-500
  }
};

/**
 * Serviço de Branding (White Label)
 * Centraliza a lógica de recuperação da identidade visual baseada no Tenant logado.
 */
export const getPortalBranding = (): TenantBranding => {
  try {
    // Busca dados do tenant armazenados no login (contendo id_entidade, cores e nome)
    const tenantData = localStorage.getItem('@Tenant:branding');
    
    if (!tenantData) return DEFAULT_BRANDING;

    const tenant = JSON.parse(tenantData);

    return {
      id_entidade: tenant.id_entidade || null,
      productName: tenant.nome_fantasia || tenant.razao_social || DEFAULT_BRANDING.productName,
      companyName: tenant.nome_fantasia || tenant.razao_social || DEFAULT_BRANDING.companyName,
      logoUrl: tenant.logo_url || null,
      theme: {
        primary: tenant.cor_primaria || DEFAULT_BRANDING.theme.primary,
        secondary: tenant.cor_secundaria || DEFAULT_BRANDING.theme.secondary,
        accent: tenant.cor_acentuacao || DEFAULT_BRANDING.theme.accent,
      }
    };
  } catch (error) {
    console.error('Erro ao recuperar branding do tenant:', error);
    return DEFAULT_BRANDING;
  }
};

/**
 * Aplica as configurações de branding no DOM (Variáveis CSS)
 * Isso permite que o sistema herde a identidade visual dinamicamente.
 */
export const applyBrandingStyles = (brand: TenantBranding) => {
  const root = document.documentElement;
  
  root.style.setProperty('--brand-primary', brand.theme.primary);
  root.style.setProperty('--brand-secondary', brand.theme.secondary);
  root.style.setProperty('--brand-accent', brand.theme.accent);
  
  // Atualiza o título da página com o nome do Tenant
  document.title = `${brand.productName} Corporativo`;
};