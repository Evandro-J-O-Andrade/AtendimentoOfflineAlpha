import { useState, useEffect } from 'react';
import { dispatcher } from '@/services/api/dispatcher';
import { ModuleCard } from '../components/ModuleCard';

interface PortalModule {
    codigo: string;
    nome: string;
    acao_frontend: string;
    icone: string;
}

export const PortalHomePage = () => {
    const [modules, setModules] = useState<PortalModule[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        dispatcher({ dominio: 'PORTAL', acao: 'MODULOS' })
            .then((r) => setModules(r.resultado || []))
            .finally(() => setLoading(false));
    }, []);

    return (
        <div className="p-6">
            <h1 className="text-2xl font-bold mb-4">Portal Corporativo</h1>
            {loading ? <p>Carregando...</p> : (
                <div className="grid grid-cols-3 gap-4">
                    {modules.map((m) => (
                        <ModuleCard key={m.acao_frontend} module={m} />
                    ))}
                </div>
            )}
        </div>
    );
};

export default PortalHomePage;