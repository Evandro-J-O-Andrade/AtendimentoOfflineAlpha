import React from 'react';
import { Outlet } from 'react-router-dom';
import { useTenant } from '@/app/providers/TenantProvider';
import { useRuntime } from '@/app/providers/RuntimeContext';
import { Search, Bell, User, LayoutGrid, HelpCircle } from 'lucide-react';
import Footer from '@/shell/Footer';

const PortalLayout: React.FC = () => {
  const { brand } = useTenant();
  const { runtime } = useRuntime();

  return (
    <div className="portal-app min-h-screen flex flex-col">
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

        <div className="hidden md:flex flex-1 max-w-2xl mx-12">
          <div className="relative w-full">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
            <input
              type="text"
              placeholder="Pesquisar aplicativos..."
              className="w-full h-11 bg-slate-100 border-none rounded-xl pl-12 pr-4 text-sm"
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
              <div className="w-8 h-8 rounded-full bg-slate-200 flex items-center justify-center">
                <User size={16} />
              </div>
              <span>Meu Perfil</span>
            </button>
          </div>
        </div>
      </header>

      <main className="flex-1 overflow-y-auto">
        <div className="portal-page">
          <Outlet />
        </div>
      </main>

      <Footer versao={runtime?.versao || "1.0.0"} />
    </div>
  );
};

export default PortalLayout;