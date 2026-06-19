interface PortalModule {
    codigo: string;
    nome: string;
    acao_frontend: string;
    icone: string;
}

interface ModuleCardProps {
    module: PortalModule;
}

export const ModuleCard = ({ module }: ModuleCardProps) => {
    return (
        <div className="p-4 border rounded-lg hover:shadow-md cursor-pointer">
            <h3 className="font-semibold">{module.nome}</h3>
            <p className="text-sm text-gray-500">{module.codigo}</p>
        </div>
    );
};