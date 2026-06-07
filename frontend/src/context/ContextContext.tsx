import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';

/**
 * Interface para Unidade e Local Operacional
 * Seguindo a estrutura multi-tenant do banco de dados.
 */
interface ContextOption {
  id: number;
  nome: string;
  sigla?: string;
}

interface ContextState {
  selectedUnidade: ContextOption | null;
  selectedLocal: ContextOption | null;
  isContextSelected: boolean;
  loadingContext: boolean;
  setContext: (unidade: ContextOption, local: ContextOption) => void;
  clearContext: () => void;
}

const ContextContext = createContext<ContextState | undefined>(undefined);

/**
 * Provider Responsável pela Alocação Operacional.
 * Armazena preferências no localStorage, mas não gerencia sessão.
 */
export const ContextProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [selectedUnidade, setSelectedUnidade] = useState<ContextOption | null>(null);
  const [selectedLocal, setSelectedLocal] = useState<ContextOption | null>(null);
  const [loadingContext, setLoadingContext] = useState(true);

  // Carregar preferências de contexto salvas
  useEffect(() => {
    const savedUnidade = localStorage.getItem('@Tenant:selectedUnidade');
    const savedLocal = localStorage.getItem('@Tenant:selectedLocal');

    if (savedUnidade && savedLocal) {
      try {
        setSelectedUnidade(JSON.parse(savedUnidade));
        setSelectedLocal(JSON.parse(savedLocal));
      } catch (e) {
        console.error("Erro ao carregar contexto do localStorage", e);
      }
    }
    setLoadingContext(false);
  }, []);

  const setContext = (unidade: ContextOption, local: ContextOption) => {
    setSelectedUnidade(unidade);
    setSelectedLocal(local);
    localStorage.setItem('@Tenant:selectedUnidade', JSON.stringify(unidade));
    localStorage.setItem('@Tenant:selectedLocal', JSON.stringify(local));
  };

  const clearContext = () => {
    setSelectedUnidade(null);
    setSelectedLocal(null);
    localStorage.removeItem('@Tenant:selectedUnidade');
    localStorage.removeItem('@Tenant:selectedLocal');
  };

  const isContextSelected = !!(selectedUnidade && selectedLocal);

  return (
    <ContextContext.Provider 
      value={{ 
        selectedUnidade, 
        selectedLocal, 
        isContextSelected, 
        loadingContext,
        setContext, 
        clearContext 
      }}
    >
      {children}
    </ContextContext.Provider>
  );
};

export const useContextContext = () => {
  const context = useContext(ContextContext);
  if (!context) {
    throw new Error('useContextContext deve ser usado dentro de um ContextProvider');
  }
  return context;
};