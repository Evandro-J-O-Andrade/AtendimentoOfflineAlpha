import { FC, useState, FormEvent } from "react";
import { useAuth } from "@/app/providers/AuthProvider";
import DynamicSidebar from "@/components/layout/DynamicSidebar";
import PatientQueue from "@/apps/operacional/components/PatientQueue";
import spApi from "@/api/spApi";

interface Patient {
    id: number | string;
    nome: string;
    cpf: string;
    data_nascimento?: string;
    telefone?: string;
}

interface Ticket {
    codigo: string;
    tipo: string;
}

/**
 * Recepcao - New Wave Enterprise
 * Setor de recepção com busca de pacientes e geração de senhas.
 * Segue LEI CANÔNICA 3: UI Premium, TypeScript.
 */
const Recepcao: FC = () => {
    const { session } = useAuth();
    const [searchTerm, setSearchTerm] = useState("");
    const [patient, setPatient] = useState<Patient | null>(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");
    const [newTicket, setNewTicket] = useState<Ticket | null>(null);
    const [selectedQueuePatient, setSelectedQueuePatient] = useState<Patient | null>(null);

    async function handleSearch(e: FormEvent) {
        e.preventDefault();
        if (!searchTerm.trim()) return;

        setLoading(true);
        setError("");
        setPatient(null);

        try {
            const data = await spApi.call('sp_consultar_pacientes', {
                p_id_sessao: session?.id_sessao,
                p_nome: searchTerm,
                p_cpf: searchTerm
            });

            const pacientes = Array.isArray(data) ? data : [];

            if (pacientes.length > 0) {
                setPatient(pacientes[0]);
            } else {
                setError("Paciente não encontrado");
            }
        } catch (err: unknown) {
            setError((err as Error)?.message || "Erro ao buscar paciente");
        } finally {
            setLoading(false);
        }
    }

    async function handleOpenFFA() {
        if (!patient) return;

        setLoading(true);
        setError("");

        try {
            await spApi.call('sp_paciente_salvar', {
                p_id_sessao: session?.id_sessao,
                p_id_paciente: patient.id,
                p_tipo_atendimento: "FFA"
            });

            setSuccess("FFA aberto com sucesso!");
            setPatient(null);
            setSearchTerm("");
        } catch (err: unknown) {
            setError((err as Error)?.message || "Erro ao abrir FFA");
        } finally {
            setLoading(false);
        }
    }

    async function handleGenerateTicket() {
        setLoading(true);
        setError("");
        setNewTicket(null);

        try {
            const resultado = await spApi.call('sp_fila_gerar_senha', {
                p_id_sessao: session?.id_sessao,
                p_tipo: 'NORMAL',
                p_origem: 'RECEPCAO'
            });
                
            if (resultado) {
                setNewTicket(resultado);
            } else {
                setError("Erro ao gerar senha");
            }
        } catch (err: unknown) {
            setError((err as Error)?.message || "Erro ao gerar senha");
        } finally {
            setLoading(false);
        }
    }

    return (
        <div className="min-h-screen bg-slate-50">
            <DynamicSidebar session={session} />
            
            <div className="ml-64 p-8">
                <div className="recepcao-page">
                    <h1 className="text-2xl font-bold mb-6">📋 Recepção</h1>

                    <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        {/* Busca de Paciente */}
                        <div className="bg-white p-6 rounded-xl shadow border">
                            <h2 className="text-lg font-semibold mb-4">Buscar Paciente</h2>
                            <form onSubmit={handleSearch} className="space-y-4">
                                <input
                                    type="text"
                                    placeholder="CPF ou Nome do paciente"
                                    value={searchTerm}
                                    onChange={(e) => setSearchTerm(e.target.value)}
                                    className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500"
                                />
                                <button type="submit" disabled={loading} className="w-full bg-indigo-600 text-white py-2 rounded-lg hover:bg-indigo-700 disabled:opacity-50">
                                    {loading ? "Buscando..." : "🔍 Buscar"}
                                </button>
                            </form>

                            {error && <div className="mt-4 p-3 bg-red-50 text-red-600 rounded-lg">{error}</div>}
                            {success && <div className="mt-4 p-3 bg-green-50 text-green-600 rounded-lg">{success}</div>}

                            {patient && (
                                <div className="mt-4 p-4 bg-slate-50 rounded-lg">
                                    <div className="space-y-2">
                                        <p><strong>Nome:</strong> {patient.nome}</p>
                                        <p><strong>CPF:</strong> {patient.cpf}</p>
                                        <p><strong>Nascimento:</strong> {patient.data_nascimento || "Não informado"}</p>
                                        <p><strong>Telefone:</strong> {patient.telefone || "Não informado"}</p>
                                    </div>
                                    <button 
                                        onClick={handleOpenFFA} 
                                        disabled={loading}
                                        className="mt-4 w-full bg-emerald-600 text-white py-2 rounded-lg hover:bg-emerald-700 disabled:opacity-50"
                                    >
                                        📝 Abrir FFA
                                    </button>
                                </div>
                            )}
                        </div>

                        {/* Gerar Senha */}
                        <div className="bg-white p-6 rounded-xl shadow border">
                            <h2 className="text-lg font-semibold mb-4">📄 Gerar Senha</h2>
                            <button 
                                onClick={handleGenerateTicket} 
                                disabled={loading}
                                className="w-full bg-amber-600 text-white py-3 rounded-lg hover:bg-amber-700 disabled:opacity-50"
                            >
                                🎫 Nova Senha
                            </button>

                            {newTicket && (
                                <div className="mt-4 p-4 bg-indigo-50 rounded-lg text-center">
                                    <span className="text-xs uppercase text-slate-500">Senha gerada:</span>
                                    <div className="text-2xl font-bold text-indigo-600">{newTicket.codigo}</div>
                                    <span className="text-xs bg-white px-2 py-1 rounded">{newTicket.tipo}</span>
                                </div>
                            )}
                        </div>

                        {/* Fila de Espera */}
                        <div className="bg-white p-6 rounded-xl shadow border">
                            <h2 className="text-lg font-semibold mb-4">⏳ Fila de Espera</h2>
                            <PatientQueue 
                                title="Fila de Espera"
                                status="AGUARDANDO"
                                onSelectPatient={setSelectedQueuePatient}
                                selectedPatient={selectedQueuePatient}
                            />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Recepcao;