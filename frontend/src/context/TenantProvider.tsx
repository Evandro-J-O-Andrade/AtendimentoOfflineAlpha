import React, { createContext, useContext, useEffect, useMemo } from 'react';
import { getPortalBranding, applyBrandingStyles, TenantBranding } from '../apps/portal/services/branding';

interface TenantContextType {
  brand: TenantBranding;
}

const TenantContext = createContext<TenantContextType | undefined>(undefined);

/**
 * Provider global responsável por garantir que o branding (White Label)
 * seja aplicado ao DOM antes da renderização das rotas.
 */
export const TenantProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  // Recupera as configurações de branding do Tenant logado (ou fallback)
  const brand = useMemo(() => getPortalBranding(), []);

  useEffect(() => {
    // Aplica variáveis CSS, Favicon e Title globalmente
    applyBrandingStyles(brand);
  }, [brand]);

  return (
    <TenantContext.Provider value={{ brand }}>
      {children}
    </TenantContext.Provider>
  );
};

/**
 * Hook para acessar os dados do Tenant/Branding em qualquer lugar do app.
 */
export const useTenant = () => {
  const context = useContext(TenantContext);
  if (!context) {
    throw new Error('useTenant deve ser usado dentro de um TenantProvider');
  }
  return context;
};