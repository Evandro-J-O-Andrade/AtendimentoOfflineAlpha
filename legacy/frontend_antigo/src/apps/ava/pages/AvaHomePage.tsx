import { GraduationCap } from "lucide-react";

export default function AvaHomePage() {
    return (
        <div className="space-y-6">
            <div className="flex items-center gap-3">
                <GraduationCap className="text-indigo-600" size={24} />
                <h2 className="text-xl font-bold text-slate-900 dark:text-white">AVA - Ambiente Virtual de Aprendizagem</h2>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div className="portal-module-card">
                    <h3>Cursos</h3>
                    <p>Trilhas de formação</p>
                </div>
                <div className="portal-module-card">
                    <h3>Avaliações</h3>
                    <p>Questionários e testes</p>
                </div>
                <div className="portal-module-card">
                    <h3>Certificados</h3>
                    <p>Certificados emitidos</p>
                </div>
            </div>
        </div>
    );
}