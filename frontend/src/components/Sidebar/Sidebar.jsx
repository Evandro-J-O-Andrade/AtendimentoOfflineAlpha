// ========================================================
// Sidebar Component - Navegação por Módulos
// ========================================================
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import {
  LayoutDashboard,
  Package,
  Pill,
  Users,
  FileText,
  Settings,
  BarChart3,
  Lock,
  Heart,
  Wrench,
  X,
  ChevronRight
} from 'lucide-react';

export default function Sidebar({ isOpen, onToggle }) {
  const navigate = useNavigate();
  const location = useLocation();
  const { usuario } = useAuth();

  // Menu items por perfil (simplificado - ajustar conforme perfil_id real)
  const menuItems = [
    {
      icon: LayoutDashboard,
      label: 'Dashboard',
      path: '/dashboard',
      roles: ['admin', 'farmaceutico', 'estoquista', 'atendente', 'gerente', 'ti']
    },
    {
      icon: Heart,
      label: 'Atendimento',
      path: '/atendimento',
      roles: ['admin', 'atendente', 'gerente']
    },
    {
      icon: Pill,
      label: 'Farmácia',
      path: '/farmacia',
      roles: ['admin', 'farmaceutico', 'gerente']
    },
    {
      icon: Package,
      label: 'Estoque',
      path: '/estoque',
      roles: ['admin', 'estoquista', 'farmaceutico', 'gerente']
    },
    {
      icon: FileText,
      label: 'Faturamento',
      path: '/faturamento',
      roles: ['admin', 'gerente']
    },
    {
      icon: BarChart3,
      label: 'Relatórios',
      path: '/relatorios',
      roles: ['admin', 'gerente']
    }
  ];

  const adminItems = [
    {
      icon: Users,
      label: 'Usuários',
      path: '/admin/usuarios',
      roles: ['admin']
    },
    {
      icon: Lock,
      label: 'Auditoria',
      path: '/admin/auditoria',
      roles: ['admin', 'gerente']
    },
    {
      icon: Wrench,
      label: 'Manutenção',
      path: '/admin/manutencao',
      roles: ['admin', 'ti']
    },
    {
      icon: Settings,
      label: 'Configurações',
      path: '/admin/configuracoes',
      roles: ['admin']
    }
  ];

  // Filtra itens conforme perfil do usuário
  const userProfile = usuario?.perfil_nome || 'user';
  const filteredItems = menuItems.filter(item => item.roles.includes(userProfile.toLowerCase()));
  const filteredAdminItems = adminItems.filter(item => item.roles.includes(userProfile.toLowerCase()));

  const isActive = (path) => location.pathname === path;

  const MenuItem = ({ icon: Icon, label, path }) => (
    <button
      onClick={() => {
        navigate(path);
        if (window.innerWidth < 1024) onToggle(); // Fecha sidebar em mobile
      }}
      className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${
        isActive(path)
          ? 'bg-blue-50 text-blue-600 font-medium'
          : 'text-gray-700 hover:bg-gray-100'
      }`}
    >
      <Icon className="w-5 h-5 flex-shrink-0" />
      <span className="flex-1 text-left">{label}</span>
      {isActive(path) && <ChevronRight className="w-4 h-4" />}
    </button>
  );

  return (
    <>
      {/* Overlay em mobile */}
      {isOpen && (
        <div
          className="fixed inset-0 bg-black/50 lg:hidden z-40"
          onClick={onToggle}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`fixed lg:static inset-y-0 left-0 w-64 bg-white border-r border-gray-200 z-40 transition-transform duration-300 ${
          isOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'
        }`}
      >
        {/* Header */}
        <div className="h-16 flex items-center justify-between px-6 border-b border-gray-200">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center text-white font-bold">
              PA
            </div>
            <span className="hidden sm:inline font-bold text-gray-900">Pronto AT</span>
          </div>
          <button onClick={onToggle} className="lg:hidden p-2 hover:bg-gray-100 rounded">
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Navigation */}
        <nav className="flex-1 px-3 py-6 space-y-2 overflow-y-auto">
          {/* Main Items */}
          <div className="space-y-1">
            {filteredItems.map((item) => (
              <MenuItem key={item.path} {...item} />
            ))}
          </div>

          {/* Admin Section */}
          {filteredAdminItems.length > 0 && (
            <div className="pt-4 mt-4 border-t border-gray-200">
              <p className="px-4 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wide">
                Administração
              </p>
              <div className="space-y-1">
                {filteredAdminItems.map((item) => (
                  <MenuItem key={item.path} {...item} />
                ))}
              </div>
            </div>
          )}
        </nav>

        {/* Footer */}
        <div className="px-4 py-4 border-t border-gray-200">
          <p className="text-xs text-gray-500 text-center">
            © 2025 Pronto Atendimento
          </p>
        </div>
      </aside>
    </>
  );
}
