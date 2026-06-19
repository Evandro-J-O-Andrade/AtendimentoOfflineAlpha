import { Users } from "lucide-react";

export default function RhHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <Users className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">RH - Recursos Humanos</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Funcionários</h3>
                    <p>Gestão de colaboradores</p>
                </div>
                <div className="portal-module-card">
                    <h3>Treinamentos</h3>
                    <p>Capacitação</p>
                </div>
                <div className="portal-module-card">
                    <h3>Avaliações</h3>
                    <p>Performance</p>
                </div>
            </div>
        </div>
    );
}