import { Shield } from "lucide-react";

export default function OuvidoriaHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <Shield className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">Ouvidoria</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Elogios</h3>
                    <p>Registre elogios</p>
                </div>
                <div className="portal-module-card">
                    <h3>Sugestões</h3>
                    <p>Envie sugestões</p>
                </div>
                <div className="portal-module-card">
                    <h3>Reclamações</h3>
                    <p>Registre reclamações</p>
                </div>
                <div className="portal-module-card">
                    <h3>Denúncias</h3>
                    <p>Registre denúncias</p>
                </div>
            </div>
        </div>
    );
}