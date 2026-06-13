import { PieChart } from "lucide-react";

export default function BiHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <PieChart className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">BI - Business Intelligence</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Dashboards</h3>
                    <p>Visualização de dados</p>
                </div>
                <div className="portal-module-card">
                    <h3>Relatórios</h3>
                    <p>Análises customizadas</p>
                </div>
                <div className="portal-module-card">
                    <h3>Analytics</h3>
                    <p>Métricas avançadas</p>
                </div>
            </div>
        </div>
    );
}