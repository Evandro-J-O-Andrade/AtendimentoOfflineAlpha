import { LayoutGrid } from "lucide-react";

export default function IntranetHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <LayoutGrid className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">Intranet Corporativa</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Notícias</h3>
                    <p>Últimas atualizações da empresa</p>
                </div>
                <div className="portal-module-card">
                    <h3>Comunicados</h3>
                    <p>Avisos importantes</p>
                </div>
                <div className="portal-module-card">
                    <h3>Eventos</h3>
                    <p>Eventos corporativos</p>
                </div>
            </div>
        </div>
    );
}