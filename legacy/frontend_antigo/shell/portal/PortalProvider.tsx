import { createContext, useContext, useState, useEffect } from 'react';

interface PortalModule {
    codigo: string;
    nome: string;
    acao_frontend: string;
    icone: string;
    category: 'operacional' | 'corporativo' | 'gestao';
    active: boolean;
}

interface PortalContextValue {
    modules: PortalModule[];
    loading: boolean;
    refreshModules: () => Promise<void>;
}

const PortalContext = createContext<PortalContextValue | undefined>(undefined);

export const PortalProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [modules, setModules] = useState<PortalModule[]>([]);
    const [loading, setLoading] = useState(true);

    const refreshModules = async () => {
        setLoading(true);
        try {
            const response = await fetch('/api/portal/modules');
            const data = await response.json();
            setModules(data.modules || []);
        } catch (err) {
            console.error('Erro ao carregar módulos:', err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        refreshModules();
    }, []);

    return (
        <PortalContext.Provider value={{ modules, loading, refreshModules }}>
            {children}
        </PortalContext.Provider>
    );
};

export const usePortal = () => {
    const ctx = useContext(PortalContext);
    if (!ctx) throw new Error('usePortal must be used within PortalProvider');
    return ctx;
};