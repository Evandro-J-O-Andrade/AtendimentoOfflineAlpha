import { LifeBuoy } from "lucide-react";

export default function ChamadosHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <LifeBuoy className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">Chamados</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Abertura</h3>
                    <p>Abrir novo chamado</p>
                </div>
                <div className="portal-module-card">
                    <h3>SLA</h3>
                    <p>Monitoramento de prazos</p>
                </div>
                <div className="portal-module-card">
                    <h3>Acompanhamento</h3>
                    <p>Status dos chamados</p>
                </div>
            </div>
        </div>
    );
}