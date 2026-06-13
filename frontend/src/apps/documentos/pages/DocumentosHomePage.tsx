import { FileText } from "lucide-react";

export default function DocumentosHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <FileText className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">Documentos</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Categorias</h3>
                    <p>Organização por categorias</p>
                </div>
                <div className="portal-module-card">
                    <h3>Workflow</h3>
                    <p>Fluxo de aprovação</p>
                </div>
                <div className="portal-module-card">
                    <h3>Pesquisa</h3>
                    <p>Busca avançada</p>
                </div>
            </div>
        </div>
    );
}