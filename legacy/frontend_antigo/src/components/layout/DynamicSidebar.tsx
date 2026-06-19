import React from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '@/app/providers/AuthProvider';

interface MenuItem {
  path: string;
  label: string;
  icon: string;
  modulo: string;
  perfis?: number[];
}

interface DynamicSidebarProps {
  session?: { id_perfil?: number; id_sessao?: number; id_unidade?: number; id_local?: number };
}

/**
 * DynamicSidebar - New Wave Enterprise
 * Sidebar dinâmico baseado em permissões e contexto.
 * Segue LEI CANÔNICA 3: UI Premium e Contexto de Operação.
 */
const DynamicSidebar: React.FC<DynamicSidebarProps> = ({ session }) => {
  const location = useLocation();
  const navigate = useNavigate();
  const { usuario, logout } = useAuth();

  const handleLogout = async () => {
    await logout();
    navigate('/login');
  };

  const menuItems: MenuItem[] = [
    { path: "/operacional", label: "Início", icon: "🏠", modulo: "Sistema" },
    { path: "/operacional/recepcao", label: "Recepção", icon: "📋", modulo: "Assistencial", perfis: [1, 2] },
    { path: "/operacional/triagem", label: "Triagem", icon: "🩺", modulo: "Assistencial", perfis: [2, 3] },
    { path: "/operacional/enfermagem", label: "Enfermagem", icon: "🏥", modulo: "Assistencial", perfis: [2, 5] },
    { path: "/operacional/medico", label: "Médico", icon: "⚕️", modulo: "Assistencial", perfis: [3] },
    { path: "/operacional/internacao", label: "Internação", icon: "🛏️", modulo: "Assistencial", perfis: [1, 3, 5] },
    { path: "/operacional/ambulancia", label: "Ambulância", icon: "🚑", modulo: "Assistencial", perfis: [1, 2] },
    { path: "/operacional/remocao", label: "Remoção", icon: "🚒", modulo: "Assistencial", perfis: [1, 2] },
    { path: "/operacional/farmacia", label: "Farmácia", icon: "💊", modulo: "Serviços", perfis: [4] },
    { path: "/operacional/laboratorio", label: "Laboratório", icon: "🧪", modulo: "Serviços", perfis: [1, 3, 4] },
    { path: "/operacional/manutencao", label: "Manutenção", icon: "🔧", modulo: "Serviços", perfis: [1] },
    { path: "/operacional/gasoterapia", label: "Gasoterapia", icon: "💨", modulo: "Especialidades", perfis: [1, 3, 5] },
    { path: "/operacional/nutricao", label: "Nutrição", icon: "🥗", modulo: "Especialidades", perfis: [1, 3, 5] },
    { path: "/operacional/assistencia-social", label: "Assist. Social", icon: "🤝", modulo: "Especialidades", perfis: [1, 5] },
    { path: "/operacional/interconsulta", label: "Interconsulta", icon: "📞", modulo: "Especialidades", perfis: [1, 3] },
    { path: "/operacional/faturamento", label: "Faturamento", icon: "💰", modulo: "Administrativo", perfis: [1, 42] },
    { path: "/operacional/estoque", label: "Estoque", icon: "📦", modulo: "Administrativo", perfis: [1, 4] },
    { path: "/operacional/pdv", label: "PDV", icon: "🛒", modulo: "Administrativo", perfis: [1] },
    { path: "/operacional/cat", label: "CAT", icon: "📋", modulo: "Administrativo", perfis: [1, 5] },
    { path: "/operacional/obito", label: "Óbito", icon: "⚰️", modulo: "Administrativo", perfis: [1, 5] },
  ];

  const filteredMenu = menuItems.filter(item => 
    !item.perfis || item.perfis.includes(Number(session?.id_perfil))
  );

  return (
    <aside className="fixed inset-y-0 left-0 w-64 bg-white border-r border-slate-100 h-screen flex flex-col">
      <div className="p-6 border-b border-slate-100">
        <h2 className="font-black text-slate-900">Menu Operacional</h2>
      </div>
      
      <nav className="flex-1 p-4 space-y-2 overflow-y-auto">
        {filteredMenu.map(item => (
          <Link
            key={item.path}
            to={item.path}
            className={`flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${
              location.pathname === item.path 
                ? 'bg-indigo-50 text-indigo-600' 
                : 'text-slate-600 hover:bg-slate-50'
            }`}
          >
            <span className="text-lg">{item.icon}</span>
            <span className="font-medium">{item.label}</span>
          </Link>
        ))}
      </nav>
      
      <div className="p-4 border-t border-slate-100">
        <div className="mb-3 text-sm">
          <p className="font-bold text-slate-900">{usuario?.nome || usuario?.login}</p>
          <p className="text-slate-500">Perfil: {session?.id_perfil}</p>
        </div>
        <button 
          onClick={handleLogout}
          className="w-full flex items-center justify-center gap-2 px-4 py-2 bg-rose-100 hover:bg-rose-200 text-rose-700 rounded-lg font-bold transition-colors"
        >
          🚪 Sair
        </button>
      </div>
    </aside>
  );
};

export default DynamicSidebar;