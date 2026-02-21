// ========================================================
// Header Component
// ========================================================
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../hooks/useAuth';
import { Menu, LogOut, User, ChevronDown, Building2, MapPin } from 'lucide-react';
import { useState } from 'react';

export default function Header({ onMenuClick }) {
  const navigate = useNavigate();
  const { usuario, logout, unidadeNome, localNome, localSala } = useAuth();
  const [showUserMenu, setShowUserMenu] = useState(false);

  const handleLogout = async () => {
    await logout();
    navigate('/login', { replace: true });
  };

  const getNomeExibicao = () => {
    if (!usuario) return 'Usuário';
    return usuario.nome || usuario.email || 'Usuário';
  };

  const getIniciais = () => {
    const nome = getNomeExibicao();
    return nome
      .split(' ')
      .map(n => n[0])
      .slice(0, 2)
      .join('')
      .toUpperCase();
  };

  const getCorAvatar = () => {
    const cores = ['bg-blue-500', 'bg-green-500', 'bg-purple-500', 'bg-pink-500', 'bg-yellow-500'];
    const index = (usuario?.id || 0) % cores.length;
    return cores[index];
  };

  return (
    <header className="bg-white border-b border-gray-200 h-16 flex items-center justify-between px-6 shadow-sm">
      {/* Left: Menu Button */}
      <button
        onClick={onMenuClick}
        className="lg:hidden p-2 hover:bg-gray-100 rounded-lg transition-colors"
      >
        <Menu className="w-6 h-6 text-gray-600" />
      </button>

      {/* Center: Context Info */}
      {unidadeNome && localNome && (
        <div className="hidden sm:flex items-center gap-4 mx-auto">
          <div className="flex items-center gap-2 px-3 py-2 bg-blue-50 rounded-lg">
            <Building2 className="w-4 h-4 text-blue-600" />
            <span className="text-sm font-medium text-gray-900">{unidadeNome}</span>
          </div>
          <div className="flex items-center gap-2 px-3 py-2 bg-green-50 rounded-lg">
            <MapPin className="w-4 h-4 text-green-600" />
            <span className="text-sm font-medium text-gray-900">
              {localNome}{localSala && ` - Sala ${localSala}`}
            </span>
          </div>
        </div>
      )}

      {/* Right: User Menu */}
      <div className="relative ml-auto">
        <button
          onClick={() => setShowUserMenu(!showUserMenu)}
          className="flex items-center gap-3 px-3 py-2 hover:bg-gray-100 rounded-lg transition-colors"
        >
          {/* Avatar */}
          <div className={`w-10 h-10 ${getCorAvatar()} rounded-full flex items-center justify-center text-white font-bold text-sm`}>
            {getIniciais()}
          </div>

          {/* User Info */}
          <div className="hidden sm:block text-left">
            <p className="text-sm font-medium text-gray-900">{getNomeExibicao()}</p>
            <p className="text-xs text-gray-500">{usuario?.perfil_nome || 'Usuário'}</p>
          </div>

          {/* Dropdown Arrow */}
          <ChevronDown className="w-4 h-4 text-gray-500" />
        </button>

        {/* Dropdown Menu */}
        {showUserMenu && (
          <div className="absolute right-0 mt-2 w-48 bg-white border border-gray-200 rounded-lg shadow-lg z-50">
            {/* Profile Info */}
            <div className="px-4 py-3 border-b border-gray-200">
              <p className="text-sm font-medium text-gray-900">{getNomeExibicao()}</p>
              <p className="text-xs text-gray-500">{usuario?.email}</p>
            </div>

            {/* Menu Items */}
            <div className="py-1">
              <button
                onClick={() => {
                  navigate('/perfil');
                  setShowUserMenu(false);
                }}
                className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 flex items-center gap-2 transition-colors"
              >
                <User className="w-4 h-4" />
                Meu Perfil
              </button>
            </div>

            {/* Logout */}
            <div className="border-t border-gray-200 py-1">
              <button
                onClick={handleLogout}
                className="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-red-50 flex items-center gap-2 transition-colors"
              >
                <LogOut className="w-4 h-4" />
                Sair
              </button>
            </div>
          </div>
        )}
      </div>
    </header>
  );
}
