import { Calendar } from "lucide-react";

export default function AgendaHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <Calendar className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">Agenda</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Eventos</h3>
                    <p>Agenda de eventos</p>
                </div>
                <div className="portal-module-card">
                    <h3>Reuniões</h3>
                    <p>Compromissos agendados</p>
                </div>
            </div>
        </div>
    );
}