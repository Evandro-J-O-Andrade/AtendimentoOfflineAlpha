import { useState } from "react";
import { useRuntimeAuth } from "../../auth/RuntimeAuthContext";
import Layout from "../../layout/Layout";
import PatientQueue from "../../components/PatientQueue";
import "./Recepcao.css";

export default function Recepcao() {
    const { authFetch } = useRuntimeAuth();
    const [searchTerm, setSearchTerm] = useState("");
    const [patient, setPatient] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");
    const [newTicket, setNewTicket] = useState(null);
    const [selectedQueuePatient, setSelectedQueuePatient] = useState(null);

    // Busca paciente por CPF ou Nome
    async function handleSearch(e) {
        e.preventDefault();
        if (!searchTerm.trim()) return;

        setLoading(true);
        setError("");
        setPatient(null);

        try {
            const res = await authFetch(`/api/operacional/pacientes?termo=${encodeURIComponent(searchTerm)}`);
            const data = await res.json();

            if (res.ok && data.pacientes && data.pacientes.length > 0) {
                setPatient(data.pacientes[0]);
            } else {
                setError("Paciente não encontrado");
            }
        } catch {
            setError("Erro ao buscar paciente");
        } finally {
            setLoading(false);
        }
    }

    // Abre FFA (Formulário de Folhas de Atendimento)
    async function handleOpenFFA() {
        if (!patient) return;

        setLoading(true);
        setError("");

        try {
            const res = await authFetch("/api/operacional/atendimentos", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    id_paciente: patient.id,
                    tipo_atendimento: "FFA"
                })
            });

            const data = await res.json();

            if (res.ok) {
                setSuccess("FFA aberto com sucesso!");
                setPatient(null);
                setSearchTerm("");
            } else {
                setError(data.error || "Erro ao abrir FFA");
            }
        } catch {
            setError("Erro ao abrir FFA");
        } finally {
            setLoading(false);
        }
    }

    // Gera nova senha
    async function handleGenerateTicket() {
        setLoading(true);
        setError("");
        setNewTicket(null);

        try {
            const res = await authFetch("/api/operacional/senhas", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    tipo: "CONSULTA"
                })
            });

            const data = await res.json();

            if (res.ok) {
                setNewTicket(data.senha);
            } else {
                setError(data.error || "Erro ao gerar senha");
            }
        } catch {
            setError("Erro ao gerar senha");
        } finally {
            setLoading(false);
        }
    }

    return (
        <Layout>
            <div className="recepcao-page">
                <h1 className="page-title">📋 Recepção</h1>

                <div className="recepcao-grid">
                    {/* Busca de Paciente */}
                    <div className="card search-card">
                        <h2>Buscar Paciente</h2>
                        <form onSubmit={handleSearch} className="search-form">
                            <input
                                type="text"
                                placeholder="CPF ou Nome do paciente"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="search-input"
                            />
                            <button type="submit" disabled={loading} className="btn-search">
                                {loading ? "Buscando..." : "🔍 Buscar"}
                            </button>
                        </form>

                        {error && <div className="alert alert-error">{error}</div>}
                        {success && <div className="alert alert-success">{success}</div>}

                        {patient && (
                            <div className="patient-info">
                                <div className="patient-details">
                                    <p><strong>Nome:</strong> {patient.nome}</p>
                                    <p><strong>CPF:</strong> {patient.cpf}</p>
                                    <p><strong>Nascimento:</strong> {patient.data_nascimento}</p>
                                    <p><strong>Telefone:</strong> {patient.telefone || "Não informado"}</p>
                                </div>
                                <button 
                                    onClick={handleOpenFFA} 
                                    disabled={loading}
                                    className="btn-primary"
                                >
                                    📝 Abrir FFA
                                </button>
                            </div>
                        )}
                    </div>

                    {/* Gerar Senha */}
                    <div className="card ticket-card">
                        <h2>📄 Gerar Senha</h2>
                        <button 
                            onClick={handleGenerateTicket} 
                            disabled={loading}
                            className="btn-ticket"
                        >
                            🎫 Nova Senha
                        </button>

                        {newTicket && (
                            <div className="new-ticket">
                                <span className="ticket-label">Senha gerada:</span>
                                <span className="ticket-number">{newTicket.codigo}</span>
                                <span className="ticket-type">{newTicket.tipo}</span>
                            </div>
                        )}
                    </div>

                    {/* Fila de Espera */}
                    <div className="card queue-card">
                        <PatientQueue 
                            title="Fila de Espera"
                            status="AGUARDANDO"
                            onSelectPatient={setSelectedQueuePatient}
                            selectedPatient={selectedQueuePatient}
                        />
                    </div>
                </div>
            </div>
        </Layout>
    );
}
