import React, { createContext, useContext, useState, useEffect } from 'react';
import type { Runtime, RuntimeContextType } from './types';

const RuntimeContext = createContext<RuntimeContextType | undefined>(undefined);

export const defaultRuntime: Runtime = {
  id_saas_entidade: null,
  id_unidade: null,
  id_local_operacional: null,
  id_perfil: null,
  contexto_selecionado: false,
};

export const RuntimeProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [runtime, setRuntimeState] = useState<Runtime>(() => {
    const saved = localStorage.getItem('runtime');
    return saved ? JSON.parse(saved) : defaultRuntime;
  });

  const setRuntime = (newRuntime: Partial<Runtime>) => {
    setRuntimeState(prev => {
      const updated = { ...prev, ...newRuntime, contexto_selecionado: !!newRuntime.id_local_operacional };
      localStorage.setItem('runtime', JSON.stringify(updated));
      return updated;
    });
  };

  useEffect(() => {
    const saved = localStorage.getItem('runtime');
    if (saved) {
      setRuntimeState(JSON.parse(saved));
    }
  }, []);

  return (
    <RuntimeContext.Provider value={{ runtime, setRuntime }}>
      {children}
    </RuntimeContext.Provider>
  );
};

export const useRuntime = () => {
  const context = useContext(RuntimeContext);
  if (context === undefined) {
    throw new Error('useRuntime must be used within a RuntimeProvider');
  }
  return context;
};

export type { Runtime };