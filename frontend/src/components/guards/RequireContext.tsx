import React from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useRuntime } from '@/app/providers/RuntimeContext';

interface RequireContextProps {
  children: JSX.Element;
}

/**
 * RequireContext - New Wave Enterprise
 * Garante que aplicações OPERACIONAIS possuam contexto selecionado.
 * Redireciona para a seleção de contexto se necessário.
 */
export const RequireContext: React.FC<RequireContextProps> = ({ children }) => {
    const context = useRuntime();
    if (!context) {
        throw new Error('useRuntime must be used within a RuntimeProvider');
    }
    const { runtime } = context;
    const location = useLocation();

    if (!runtime.contexto_selecionado) {
        return <Navigate to="/contexto" state={{ from: location }} replace />;
    }

    return children;
};

export default RequireContext;