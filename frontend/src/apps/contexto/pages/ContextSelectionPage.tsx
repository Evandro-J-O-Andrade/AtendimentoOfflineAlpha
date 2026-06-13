import { useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { useAuth } from "@/apps/operacional/auth/AuthProvider";
import { useRuntime } from "@/app/providers/RuntimeContext";

interface Unidade {
    id_unidade: number;
    nome: string;
}

/**
 * ContextSelectionPage - New Wave Enterprise
 * Página de seleção de contexto operacional.
 */
export default function ContextSelectionPage() {
    const { usuario } = useAuth();
    const { setRuntime } = useRuntime();
    const navigate = useNavigate();
    const location = useLocation();
    
    const [selectedUnidade, setSelectedUnidade] = useState<Unidade | null>(null);
    const [selectedLocal, setSelectedLocal] = useState<number | null>(null);
    const [loading, setLoading] = useState(false);

    const handleConfirm = async () => {
        if (!selectedUnidade || !selectedLocal) return;
        
        setLoading(true);
        
        setRuntime({
            id_unidade: selectedUnidade.id_unidade,
            id_local_operacional: selectedLocal,
            id_perfil: usuario?.id_perfil || 1,
        });
        
        const redirectTo = location.state?.from?.pathname || "/portal";
        navigate(redirectTo, { replace: true });
    };

    return (
        <div className="min-h-screen flex items-center justify-center bg-slate-50 p-4">
            <div className="w-full max-w-md space-y-8">
                <div className="text-center">
                    <h1 className="text-2xl font-black text-slate-900">
                        Seleção de Contexto
                    </h1>
                    <p className="text-slate-500 mt-2">
                        Escolha a unidade e local para operação
                    </p>
                </div>

                <div className="space-y-4">
                    <div>
                        <label className="block text-sm font-bold text-slate-700 mb-2">
                            Unidade
                        </label>
                        <select
                            onChange={(e) => {
                                const id = Number(e.target.value);
                                setSelectedUnidade({ id_unidade: id, nome: `Unidade ${id}` });
                            }}
                            className="w-full h-12 px-4 rounded-xl border border-slate-200 bg-white"
                        >
                            <option value="">Selecione...</option>
                            <option value="1">Unidade 1</option>
                            <option value="2">Unidade 2</option>
                        </select>
                    </div>

                    <div>
                        <label className="block text-sm font-bold text-slate-700 mb-2">
                            Local
                        </label>
                        <select
                            onChange={(e) => setSelectedLocal(Number(e.target.value))}
                            disabled={!selectedUnidade}
                            className="w-full h-12 px-4 rounded-xl border border-slate-200 bg-white disabled:opacity-50"
                        >
                            <option value="">Selecione...</option>
                            <option value="1">Recepção</option>
                            <option value="2">Consultório 1</option>
                        </select>
                    </div>
                </div>

                <button
                    onClick={handleConfirm}
                    disabled={!selectedUnidade || !selectedLocal || loading}
                    className="w-full h-12 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-bold transition-all disabled:opacity-50"
                >
                    Confirmar
                </button>
            </div>
        </div>
    );
}