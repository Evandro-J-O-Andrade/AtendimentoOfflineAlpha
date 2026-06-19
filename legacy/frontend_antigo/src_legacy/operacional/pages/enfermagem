import { useState } from "react";
import { useAuth } from "../../../../context/AuthProvider";
import spApi from "../../../../api/spApi";
import Layout from "../../layout/Layout";
import PatientQueue from "../../components/PatientQueue";
import "./Enfermagem.css";

export default function Enfermagem() {
    const { session } = useAuth();
    const [selectedPatient, setSelectedPatient] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");

    // Formulário de enfermagem
    const [observations, setObservations] = useState("");
    const [procedures, setProcedures] = useState([]);

    // Chamar próximo paciente
    async function handleCallNext() {
        setLoading(true);
        setError("");

        try {
            const data = await spApi.call('sp_atendimento_chamar_proximo', {
                p_id_sessao: session?.id_sessao,
                p_id_unidade: session?.id_unidade,
                p_tipo_local: "ENFERMAGEM"
            });

            if (data?.sucesso && data?.resultado) {
                setSelectedPatient(data.resultado);
            } else {
                setError(data?.mensagem || "Erro ao chamar paciente");
            }
        } catch (e) {
            setError(e.message || "Erro de comunicação");
        } finally {
            setLoading(false);
        }
    }

    // Finalizar atendimento de enfermagem
    async function handleFinish() {
        if (!selectedPatient) return;

        setLoading(true);
        setError("");

        try {
            const payload = {
                id_atendimento: selectedPatient.id,
                status: "ATENDIDO",
                observacoes_enfermagem: observations,
                procedimentos: procedures,
                acao: "FINALIZAR_ENFERMAGEM"
            };

            const data = await spApi.call('sp_atendimento_finalizar_enfermagem', {
                p_id_sessao: session?.id_sessao,
                p_payload: JSON.stringify(payload)
            });

            if (data?.sucesso) {
                setSuccess("Atendimento de enfermagem finalizado!");
                setSelectedPatient(null);
                setObservations("");
                setProcedures([]);
            } else {
                setError(data?.mensagem || "Erro ao finalizar");
            }
        } catch (e) {
            setError(e.message || "Erro ao finalizar");
        } finally {
            setLoading(false);
        }
    }

    const procedureList = [
        "Curativo",
        "Medicação EV",
        "Medicação IM",
        "Medicação VO",
        "Sonda Nasogástrica",
        "Sonda Vesical",
        "Aerosol",
        "Verificação de Sinais Vitais",
        "Outros"
    ];

    function toggleProcedure(proc) {
        setProcedures(prev => 
            prev.includes(proc) 
                ? prev.filter(p => p !== proc)
                : [...prev, proc]
        );
    }

    return (
        <Layout>
            <div className="enfermagem-page">
                <h1 className="page-title">🏥 Enfermagem</h1>

                <div className="enfermagem-grid">
                    {/* Fila de Espera */}
                    <div className="card queue-section">
                        <PatientQueue
                            title="Pacientes para Atendimento"
                            status="EM_ATENDIMENTO"
                            onSelectPatient={setSelectedPatient}
                            selectedPatient={selectedPatient}
                        />

                        <button
                            onClick={handleCallNext}
                            disabled={loading}
                            className="btn-call-next"
                        >
                            📢 Chamar Próximo
                        </button>
                    </div>

                    {/* Área de Atendimento */}
                    <div className="card nursing-form">
                        <h2>🩺 Atendimento de Enfermagem</h2>

                        {error && <div className="alert alert-error">{error}</div>}
                        {success && <div className="alert alert-success">{success}</div>}

                        {selectedPatient ? (
                            <>
                                <div className="patient-header">
                                    <span className="ticket">{selectedPatient.senha}</span>
                                    <span className="patient-name">{selectedPatient.nome_paciente}</span>
                                    {selectedPatient.classificacao_risco && (
                                        <span className="risk-badge">
                                            {selectedPatient.classificacao_risco}
                                        </span>
                                    )}
                                </div>

                                {/* Procedimentos */}
                                <div className="form-section">
                                    <h3>Procedimentos Realizados</h3>
                                    <div className="procedure-options">
                                        {procedureList.map(proc => (
                                            <label 
                                                key={proc} 
                                                className={`procedure-option ${procedures.includes(proc) ? "selected" : ""}`}
                                            >
                                                <input
                                                    type="checkbox"
                                                    checked={procedures.includes(proc)}
                                                    onChange={() => toggleProcedure(proc)}
                                                />
                                                <span>{proc}</span>
                                            </label>
                                        ))}
                                    </div>
                                </div>

                                {/* Observações */}
                                <div className="form-section">
                                    <h3>Observações</h3>
                                    <textarea
                                        value={observations}
                                        onChange={(e) => setObservations(e.target.value)}
                                        placeholder="Digite as observações do atendimento..."
                                        rows={4}
                                    />
                                </div>

                                {/* Ações */}
                                <div className="nursing-actions">
                                    <button
                                        onClick={handleFinish}
                                        disabled={loading}
                                        className="btn-finish"
                                    >
                                        ✅ Finalizar Atendimento
                                    </button>
                                </div>
                            </>
                        ) : (
                            <div className="no-patient">
                                <p>Nenhum paciente em atendimento</p>
                                <p className="hint">Selecione um paciente da fila ou clique em "Chamar Próximo"</p>
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </Layout>
    );
}
