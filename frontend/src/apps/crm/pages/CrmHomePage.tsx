import { BarChart3 } from "lucide-react";

export default function CrmHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <BarChart3 className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">CRM - Customer Relationship</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Clientes</h3>
                    <p>Cadastro e gestão</p>
                </div>
                <div className="portal-module-card">
                    <h3>Oportunidades</h3>
                    <p>Pipeline de vendas</p>
                </div>
                <div className="portal-module-card">
                    <h3>Relacionamento</h3>
                    <p>Histórico de interações</p>
                </div>
            </div>
        </div>
    );
}