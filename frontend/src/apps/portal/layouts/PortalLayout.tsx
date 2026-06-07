import React from 'react';
import { Outlet } from 'react-router-dom';
import { useTenant } from '@/context/TenantProvider';
import { Search, Bell, User, LayoutGrid, HelpCircle } from 'lucide-react';

/**
 * Layout Oficial do Portal Corporativo
 * Seguindo referências de design do Microsoft 365 e Notion.
 */
const PortalLayout: React.FC = () => {
  const { brand } = useTenant();
  const currentYear = new Date().getFullYear();

  return (
    <div className="min-h-screen flex flex-col">
      {/* Header Estilo Glassmorphism */}
      <header className="portal-header">
        <div className="portal-brand">
          <div className="portal-brand-logo bg-brand-primary">
            {brand.logoUrl ? (
              <img src={brand.logoUrl} alt={brand.productName} className="w-full h-full object-cover" />
            ) : (
              <LayoutGrid size={20} />
            )}
          </div>
          <div className="portal-brand-copy">
            <strong>{brand.productName}</strong>
            <small>Ecossistema Corporativo</small>
          </div>
        </div>

        {/* Busca Global (Estilo Microsoft 365) */}
        <div className="hidden md:flex flex-1 max-w-2xl mx-12">
          <div className="relative w-full">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
            <input 
              type="text" 
              placeholder="Pesquisar aplicativos, documentos e pessoas..."
              className="w-full h-11 bg-slate-100 dark:bg-slate-900 border-none rounded-xl pl-12 pr-4 text-sm focus:ring-2 focus:ring-brand-primary/20 transition-all"
            />
          </div>
        </div>

        <div className="portal-header-actions">
          <button className="portal-icon-button"><HelpCircle size={20} /></button>
          <button className="portal-icon-button">
            <Bell size={20} />
            <span className="portal-notification-dot bg-brand-accent"></span>
          </button>
          
          <div className="portal-profile">
            <button className="portal-profile-trigger">
              <div className="w-8 h-8 rounded-full bg-slate-200 dark:bg-slate-800 flex items-center justify-center text-slate-600 dark:text-slate-300">
                <User size={16} />
              </div>
              <span className="text-slate-700 dark:text-slate-200 font-bold tracking-tight">Meu Perfil</span>
            </button>
          </div>
        </div>
      </header>

      {/* Conteúdo Principal */}
      <main className="flex-1 overflow-y-auto">
        <div className="portal-page">
          <Outlet />
        </div>
      </main>

      {/* Rodapé Institucional (Compliance) */}
      <footer className="p-8 border-t border-slate-100 dark:border-slate-900 text-center md:flex md:justify-between md:items-center">
        <p className="text-xs text-slate-400 font-medium tracking-wide uppercase">
          &copy; {currentYear} {brand.productName} • Desenvolvido por <span className="text-brand-primary font-bold">New Wave Sistemas Digitais</span>
        </p>
        <div className="flex gap-6 mt-4 md:mt-0 justify-center">
          <a href="#" className="text-xs text-slate-400 hover:text-brand-primary transition-colors">Privacidade</a>
          <a href="#" className="text-xs text-slate-400 hover:text-brand-primary transition-colors">Termos</a>
          <a href="#" className="text-xs text-slate-400 hover:text-brand-primary transition-colors">Suporte</a>
        </div>
      </footer>
    </div>
  );
};

export default PortalLayout;