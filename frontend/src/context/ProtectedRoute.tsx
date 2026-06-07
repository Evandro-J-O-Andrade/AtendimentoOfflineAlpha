import React from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext'; 
import { useContextContext } from './ContextContext';

interface ProtectedRouteProps {
  children: React.ReactNode;
  guard?: 'requireAuth' | 'requireContext';
}

/**
 * Componente de Proteção de Rota Evoluído.
 * 
 * Guard 'requireAuth' (Nível 1): Exige apenas login. 
 *   - Uso: Portal, Intranet, Perfil.
 * 
 * Guard 'requireContext' (Nível 2): Exige login + unidade/local selecionado.
 *   - Uso: HIS (Recepção, Triagem, Médico).
 */
export const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ 
  children, 
  guard = 'requireAuth' 
}) => {
  const { isAuthenticated, loadingAuth } = useAuth();
  const { isContextSelected, loadingContext } = useContextContext();
  const location = useLocation();

  // Aguarda carregamento de sessão e preferências
  if (loadingAuth || loadingContext) {
    return (
      <div className="flex items-center justify-center h-screen bg-gray-50">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600"></div>
      </div>
    );
  }

  // Validação Nível 1: Autenticação
  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  // Validação Nível 2: Contexto Operacional
  if (guard === 'requireContext' && !isContextSelected) {
    // Se tentar acessar o HIS sem contexto, redireciona para a seleção
    return <Navigate to="/contexto-selection" state={{ from: location }} replace />;
  }

  // Se estiver autenticado e tentar acessar login, manda para o Portal
  if (location.pathname === '/login' && isAuthenticated) {
    return <Navigate to="/portal" replace />;
  }

  return <>{children}</>;
};

export default ProtectedRoute;