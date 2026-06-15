import { FC, useState, useEffect } from "react";
import { useAuth } from "@/app/providers/AuthProvider";
import { useRuntime } from "@/app/providers/RuntimeContext";
import DynamicSidebar from "@/components/layout/DynamicSidebar";
import spApi from "@/api/spApi";

/**
 * Triagem - New Wave Enterprise
 * Setor de triagem com classificação de risco.
 * Segue LEI CANÔNICA 3: UI Premium, TypeScript, Contexto de Operação.
 */
const Triagem: FC = () => {
    const { session } = useAuth();
    const { runtime } = useRuntime();
    const [loading, setLoading] = useState(false);
    const [patient, setPatient] = useState(null);
    const [riskLevel, setRiskLevel] = useState("VERDE");
    const [symptoms, setSymptoms] = useState("");

    const handleStartTriagem = async () => {
        setLoading(true);
        try {
            await spApi.call('sp_triagem_iniciar', {
                p_id_sessao: session?.id_sessao,
                p_id_local: runtime?.id_local_operacional,
                p_risco: riskLevel,
                p_queixa: symptoms
            });
            alert('Triagem iniciada com sucesso!');
        } catch (err) {
            alert('Erro ao iniciar triagem');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="min-h-screen bg-slate-50">
            <DynamicSidebar session={session} />
            
            <div className="ml-64 p-8">
                <h1 className="text-2xl font-bold mb-6">🩺 Triagem</h1>
                
                <div className="bg-white p-6 rounded-xl shadow border max-w-2xl">
                    <div className="space-y-4">
                        <div>
                            <label className="block text-sm font-bold text-slate-700 mb-2">Classificação de Risco</label>
                            <select 
                                value={riskLevel} 
                                onChange={(e) => setRiskLevel(e.target.value)}
                                className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500"
                            >
                                <option value="VERDE">🟢 Verde - Não Urgente</option>
                                <option value="AMARELO">🟡 Amarelo - Urgente</option>
                                <option value="LARANJA">🟠 Laranja - Muito Urgente</option>
                                <option value="VERMELHO">🔴 Vermelho - Emergência</option>
                            </select>
                        </div>

                        <div>
                            <label className="block text-sm font-bold text-slate-700 mb-2">Queixa Principal</label>
                            <textarea
                                value={symptoms}
                                onChange={(e) => setSymptoms(e.target.value)}
                                placeholder="Descreva os sintomas..."
                                className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500"
                                rows={4}
                            />
                        </div>

                        <button
                            onClick={handleStartTriagem}
                            disabled={loading}
                            className="w-full bg-indigo-600 text-white py-3 rounded-lg font-bold hover:bg-indigo-700 disabled:opacity-50"
                        >
                            {loading ? "Processando..." : "Iniciar Triagem"}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Triagem;