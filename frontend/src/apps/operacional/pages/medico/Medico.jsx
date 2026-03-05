import { useState } from "react";
import { useRuntimeAuth } from "../../auth/RuntimeAuthContext";
import Layout from "../../layout/Layout";
import PatientQueue from "../../components/PatientQueue";
import "./Medico.css";

export default function Medico() {
    const { authFetch } = useRuntimeAuth();
    const [selectedPatient, setSelectedPatient] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");

    // Formulário médico
    const [complaint, setComplaint] = useState("");
    const [diagnosis, setDiagnosis] = useState("");
    const [conduct, setConduct] = useState({
        medicacao: false,
        exame: false,
        observacao: false,
        alta: false,
        internacao: false,
        encaminhamento: false
    });
    const [prescription, setPrescription] = useState("");
    const [examRequest, setExamRequest] = useState("");

    // Chamar próximo paciente
    async function handleCallNext() {
        setLoading(true);
        setError("");

        try {
            const res = await authFetch("/api/operacional/atendimentos/chamar", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ tipo_local: "MEDICO" })
            });

            const data = await res.json();

            if (res.ok) {
                setSelectedPatient(data.atendimento);
            } else {
                setError(data.error || "Erro ao chamar paciente");
            }
        } catch {
            setError("Erro de comunicação");
        } finally {
            setLoading(false);
        }
    }

    // Atualizar conduta
    function handleConductChange(key) {
        setConduct(prev => ({ ...prev, [key]: !prev[key] }));
    }

    // Finalizar atendimento
    async function handleFinish() {
        if (!selectedPatient) return;

        setLoading(true);
        setError("");

        try {
            const res = await authFetch(`/api/operacional/atendimentos/${selectedPatient.id}`, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    status: "ATENDIDO",
                    queixa_principal: complaint,
                    diagnostico: diagnosis,
                    conduta: conduct,
                    prescricao: prescription,
                    solicitacao_exame: examRequest,
                    acao: "FINALIZAR_ATENDIMENTO"
                })
            });

            const data = await res.json();

            if (res.ok) {
                setSuccess("Atendimento finalizado com sucesso!");
                setSelectedPatient(null);
                resetForm();
            } else {
                setError(data.error || "Erro ao finalizar atendimento");
            }
        } catch {
            setError("Erro ao finalizar atendimento");
        } finally {
            setLoading(false);
        }
    }

    // Encaminhar
    async function handleForward(destination) {
        if (!selectedPatient) return;

        setLoading(true);
        setError("");

        try {
            const res = await authFetch(`/api/operacional/atendimentos/${selectedPatient.id}/encaminhar`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ destino: destination })
            });

            const data = await res.json();

            if (res.ok) {
                setSuccess(`Pacienteionado para ${destination}!`);
                setSelectedPatient(null);
                resetForm();
            } else {
                setError(data.error || "Erro ao encaminhar");
            }
        } catch {
            setError("Erro ao encaminhar");
        } finally {
            setLoading(false);
        }
    }

    function resetForm() {
        setComplaint("");
        setDiagnosis("");
        setConduct({
            medicacao: false,
            exame: false,
            observacao: false,
            alta: false,
            internacao: false,
            encaminhamento: false
        });
        setPrescription("");
        setExamRequest("");
    }

    return (
        <Layout>
            <div className="medico-page">
                <h1 className="page-title">⚕️ Médico</h1>

                <div className="medico-grid">
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
                    <div className="card consultation-form">
                        <h2>📝 Consulta Médica</h2>

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

                                {/* Queixa Principal */}
                                <div className="form-section">
                                    <h3>Queixa Principal</h3>
                                    <textarea
                                        value={complaint}
                                        onChange={(e) => setComplaint(e.target.value)}
                                        placeholder="Descreva a queixa principal do paciente..."
                                        rows={3}
                                    />
                                </div>

                                {/* Diagnóstico */}
                                <div className="form-section">
                                    <h3>Diagnóstico</h3>
                                    <textarea
                                        value={diagnosis}
                                        onChange={(e) => setDiagnosis(e.target.value)}
                                        placeholder="Diagnóstico clínico..."
                                        rows={3}
                                    />
                                </div>

                                {/* Conduta */}
                                <div className="form-section">
                                    <h3>Conduta</h3>
                                    <div className="conduct-options">
                                        <label className={`conduct-option ${conduct.medicacao ? "selected" : ""}`}>
                                            <input
                                                type="checkbox"
                                                checked={conduct.medicacao}
                                                onChange={() => handleConductChange("medicacao")}
                                            />
                                            <span>💊 Medicação</span>
                                        </label>
                                        <label className={`conduct-option ${conduct.exame ? "selected" : ""}`}>
                                            <input
                                                type="checkbox"
                                                checked={conduct.exame}
                                                onChange={() => handleConductChange("exame")}
                                            />
                                            <span>🧪 Exame</span>
                                        </label>
                                        <label className={`conduct-option ${conduct.observacao ? "selected" : ""}`}>
                                            <input
                                                type="checkbox"
                                                checked={conduct.observacao}
                                                onChange={() => handleConductChange("observacao")}
                                            />
                                            <span>🏥 Observação</span>
                                        </label>
                                        <label className={`conduct-option ${conduct.alta ? "selected" : ""}`}>
                                            <input
                                                type="checkbox"
                                                checked={conduct.alta}
                                                onChange={() => handleConductChange("alta")}
                                            />
                                            <span>✅ Alta</span>
                                        </label>
                                        <label className={`conduct-option ${conduct.internacao ? "selected" : ""}`}>
                                            <input
                                                type="checkbox"
                                                checked={conduct.internacao}
                                                onChange={() => handleConductChange("internacao")}
                                            />
                                            <span>🛏️ Internação</span>
                                        </label>
                                        <label className={`conduct-option ${conduct.encaminhamento ? "selected" : ""}`}>
                                            <input
                                                type="checkbox"
                                                checked={conduct.encaminhamento}
                                                onChange={() => handleConductChange("encaminhamento")}
                                            />
                                            <span>➡️ Encaminhamento</span>
                                        </label>
                                    </div>
                                </div>

                                {/* Prescrição */}
                                {conduct.medicacao && (
                                    <div className="form-section">
                                        <h3>Prescrição</h3>
                                        <textarea
                                            value={prescription}
                                            onChange={(e) => setPrescription(e.target.value)}
                                            placeholder="Prescrição de medicamentos..."
                                            rows={4}
                                        />
                                    </div>
                                )}

                                {/* Solicitação de Exames */}
                                {conduct.exame && (
                                    <div className="form-section">
                                        <h3>Solicitação de Exames</h3>
                                        <textarea
                                            value={examRequest}
                                            onChange={(e) => setExamRequest(e.target.value)}
                                            placeholder="Exames solicitados..."
                                            rows={3}
                                        />
                                    </div>
                                )}

                                {/* Ações */}
                                <div className="consultation-actions">
                                    <button
                                        onClick={handleFinish}
                                        disabled={loading}
                                        className="btn-finish"
                                    >
                                        ✅ Finalizar Atendimento
                                    </button>
                                    <div className="forward-buttons">
                                        <button
                                            onClick={() => handleForward("FARMACIA")}
                                            disabled={loading}
                                            className="btn-forward-farmacia"
                                        >
                                            💊 Farmácia
                                        </button>
                                        <button
                                            onClick={() => handleForward("ENFERMAGEM")}
                                            disabled={loading}
                                            className="btn-forward-enfermagem"
                                        >
                                            🩺 Enfermagem
                                        </button>
                                    </div>
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
