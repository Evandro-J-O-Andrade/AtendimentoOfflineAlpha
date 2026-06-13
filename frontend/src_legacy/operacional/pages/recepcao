import { useState } from "react";
import { useAuth } from "../../../../context/AuthProvider";
import Layout from "../../layout/Layout";
import PatientQueue from "../../components/PatientQueue";
import spApi from "../../../../api/spApi";
import "./Recepcao.css";

export default function Recepcao() {
    const { session } = useAuth();
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
        } catch (e) {
            setError(e.message || "Erro ao buscar paciente");
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
            await spApi.call('sp_paciente_salvar', {
                p_id_sessao: session?.id_sessao,
                p_id_paciente: patient.id,
                p_tipo_atendimento: "FFA"
            });

            setSuccess("FFA aberto com sucesso!");
            setPatient(null);
            setSearchTerm("");
        } catch (e) {
            setError(e.message || "Erro ao abrir FFA");
        } finally {
            setLoading(false);
        }
    }

    // Gera nova senha via Dispatcher
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
        } catch (e) {
            setError(e.message || "Erro ao gerar senha");
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
 
