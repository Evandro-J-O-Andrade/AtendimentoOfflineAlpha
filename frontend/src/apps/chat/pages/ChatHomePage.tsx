import { Send } from "lucide-react";

export default function ChatHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <Send className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">Chat Corporativo</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Mensagens</h3>
                    <p>Conversas diretas</p>
                </div>
                <div className="portal-module-card">
                    <h3>Grupos</h3>
                    <p>Equipes e projetos</p>
                </div>
            </div>
        </div>
    );
}