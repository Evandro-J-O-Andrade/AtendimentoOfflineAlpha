import { MessageCircle } from "lucide-react";

export default function WikiHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">Wiki</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Artigos</h3>
                    <p>Base de conhecimento</p>
                </div>
                <div className="portal-module-card">
                    <h3>Categorias</h3>
                    <p>Organização por temas</p>
                </div>
            </div>
        </div>
    );
}