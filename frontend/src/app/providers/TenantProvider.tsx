import React, { createContext, useContext, useState, useEffect } from 'react';
import type { TenantConfig } from './types';

const TenantContext = createContext<{
  tenant: TenantConfig | null;
  brand: TenantConfig;
}>({ tenant: null, brand: {} as TenantConfig });

export const TenantProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [tenant, setTenant] = useState<TenantConfig | null>(null);

  useEffect(() => {
    const loadBranding = async () => {
      const mockBranding: TenantConfig = {
        name: 'Organização Global Alpha',
        logo: '/assets/logo-tenant.svg',
        logoUrl: '/assets/logo-tenant.svg',
        productName: 'Organização Global Alpha',
        primaryColor: '#4f46e5',
        theme: 'light'
      };
      setTenant(mockBranding);
      
      document.documentElement.style.setProperty('--brand-primary', mockBranding.primaryColor);
      document.title = `${mockBranding.name} | New Wave Enterprise`;
    };

    loadBranding();
  }, []);

  return (
    <TenantContext.Provider value={{ tenant, brand: tenant || {} as TenantConfig }}>
      <div className={`tenant-wrapper ${tenant?.theme}`}>
        {children}
      </div>
    </TenantContext.Provider>
  );
};

export const useTenant = () => useContext(TenantContext);