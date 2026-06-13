import { Phone } from "lucide-react";

export default function RamalHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <Phone className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">Ramal</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Contatos</h3>
                    <p>Diretório telefônico</p>
                </div>
                <div className="portal-module-card">
                    <h3>Departamentos</h3>
                    <p>Ramais por setor</p>
                </div>
            </div>
        </div>
    );
}