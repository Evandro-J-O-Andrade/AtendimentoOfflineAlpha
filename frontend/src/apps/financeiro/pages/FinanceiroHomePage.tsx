import { CreditCard } from "lucide-react";

export default function FinanceiroHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <CreditCard className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">Financeiro</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Contas a Pagar</h3>
                    <p>Gestão de despesas</p>
                </div>
                <div className="portal-module-card">
                    <h3>Contas a Receber</h3>
                    <p>Gestão de receitas</p>
                </div>
                <div className="portal-module-card">
                    <h3>Fluxo de Caixa</h3>
                    <p>Controle financeiro</p>
                </div>
            </div>
        </div>
    );
}