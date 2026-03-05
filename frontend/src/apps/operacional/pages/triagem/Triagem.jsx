import { useState } from "react";
import { useRuntimeAuth } from "../../auth/RuntimeAuthContext";
import Layout from "../../layout/Layout";
import PatientQueue from "../../components/PatientQueue";
import "./Triagem.css";

export default function Triagem() {
    const { authFetch } = useRuntimeAuth();
    const [selectedPatient, setSelectedPatient] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");
    
    // Formulário de triagem
    const [vitalSigns, setVitalSigns] = useState({
        pressao_sistolica: "",
        pressao_diastolica: "",
        temperatura: "",
        frecuencia_cardiaca: "",
        saturacao: "",
        respiracao: "",
        peso: "",
        altura: ""
    });
    
    const [classification, setClassification] = useState(null);
    const [observations, setObservations] = useState("");

    // Atualiza sinais vitais
    function handleVitalChange(field, value) {
        setVitalSigns(prev => ({ ...prev, [field]: value }));
    }

    // Chamar próximo paciente
    async function handleCallNext() {
        setLoading(true);
        setError("");
        
        try {
            const res = await authFetch("/api/operacional/atendimentos/chamar", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ tipo_local: "TRIAGEM" })
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

    // Finalizar triagem
    async function handleFinishTriage() {
        if (!selectedPatient || !classification) {
            setError("Selecione a classificação de risco");
            return;
        }

        setLoading(true);
        setError("");

        try {
            const res = await authFetch(`/api/operacional/atendimentos/${selectedPatient.id}`, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    status: "EM_ATENDIMENTO",
                    prioridade: classification,
                    sinais_vitais: vitalSigns,
                    observacoes_triagem: observations,
                    acao: "FINALIZAR_TRIAGEM"
                })
            });

            const data = await res.json();

            if (res.ok) {
                setSuccess("Triagem finalizada com sucesso!");
                setSelectedPatient(null);
                setClassification(null);
                setVitalSigns({
                    pressao_sistolica: "",
                    pressao_diastolica: "",
                    temperatura: "",
                    frecuencia_cardiaca: "",
                    saturacao: "",
                    respiracao: "",
                    peso: "",
                    altura: ""
                });
                setObservations("");
            } else {
                setError(data.error || "Erro ao finalizar triagem");
            }
        } catch {
            setError("Erro ao finalizar triagem");
        } finally {
            setLoading(false);
        }
    }

    // Encaminhar para médico
    async function handleForwardToDoctor() {
        if (!selectedPatient) return;

        setLoading(true);
        setError("");

        try {
            const res = await authFetch(`/api/operacional/atendimentos/${selectedPatient.id}/encaminhar`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    destino: "MEDICO"
                })
            });

            const data = await res.json();

            if (res.ok) {
                setSuccess("Paciente encaminhado para médico!");
                setSelectedPatient(null);
                setClassification(null);
            } else {
                setError(data.error || "Erro ao encaminhar");
            }
        } catch {
            setError("Erro ao encaminhar");
        } finally {
            setLoading(false);
        }
    }

    const riskLevels = [
        { value: 1, label: "Emergência", color: "#dc2626", icon: "🔴" },
        { value: 2, label: "Muito Urgente", color: "#f97316", icon: "🟠" },
        { value: 3, label: "Urgente", color: "#eab308", icon: "🟡" },
        { value: 4, label: "Pouco Urgente", color: "#22c55e", icon: "🟢" },
        { value: 5, label: "Não Urgente", color: "#3b82f6", icon: "🔵" }
    ];

    return (
        <Layout>
            <div className="triagem-page">
                <h1 className="page-title">🩺 Triagem</h1>

                <div className="triagem-grid">
                    {/* Fila de Espera */}
                    <div className="card queue-section">
                        <PatientQueue 
                            title="Pacientes para Triagem"
                            status="AGUARDANDO_TRIAGEM"
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

                    {/* Área de Triagem */}
                    <div className="card triage-form">
                        <h2>🎯 Classificação de Risco</h2>
                        
                        {error && <div className="alert alert-error">{error}</div>}
                        {success && <div className="alert alert-success">{success}</div>}

                        {selectedPatient ? (
                            <>
                                <div className="patient-header">
                                    <span className="ticket">{selectedPatient.senha}</span>
                                    <span className="patient-name">{selectedPatient.nome_paciente}</span>
                                </div>

                                {/* Sinais Vitais */}
                                <div className="vital-signs">
                                    <h3>Sinais Vitais</h3>
                                    <div className="vitals-grid">
                                        <div className="vital-input">
                                            <label>PA Sistólica</label>
                                            <input 
                                                type="number" 
                                                value={vitalSigns.pressao_sistolica}
                                                onChange={(e) => handleVitalChange("pressao_sistolica", e.target.value)}
                                                placeholder="120"
                                            />
                                            <span className="unit">mmHg</span>
                                        </div>
                                        <div className="vital-input">
                                            <label>PA Diastólica</label>
                                            <input 
                                                type="number" 
                                                value={vitalSigns.pressao_diastolica}
                                                onChange={(e) => handleVitalChange("pressao_diastolica", e.target.value)}
                                                placeholder="80"
                                            />
                                            <span className="unit">mmHg</span>
                                        </div>
                                        <div className="vital-input">
                                            <label>Temperatura</label>
                                            <input 
                                                type="number" 
                                                step="0.1"
                                                value={vitalSigns.temperatura}
                                                onChange={(e) => handleVitalChange("temperatura", e.target.value)}
                                                placeholder="36.5"
                                            />
                                            <span className="unit">°C</span>
                                        </div>
                                        <div className="vital-input">
                                            <label>FC</label>
                                            <input 
                                                type="number" 
                                                value={vitalSigns.frecuencia_cardiaca}
                                                onChange={(e) => handleVitalChange("frecuencia_cardiaca", e.target.value)}
                                                placeholder="80"
                                            />
                                            <span className="unit">bpm</span>
                                        </div>
                                        <div className="vital-input">
                                            <label>Saturação</label>
                                            <input 
                                                type="number" 
                                                value={vitalSigns.saturacao}
                                                onChange={(e) => handleVitalChange("saturacao", e.target.value)}
                                                placeholder="98"
                                            />
                                            <span className="unit">%</span>
                                        </div>
                                        <div className="vital-input">
                                            <label>Respirações</label>
                                            <input 
                                                type="number" 
                                                value={vitalSigns.respiracao}
                                                onChange={(e) => handleVitalChange("respiracao", e.target.value)}
                                                placeholder="16"
                                            />
                                            <span className="unit">rpm</span>
                                        </div>
                                    </div>
                                </div>

                                {/* Classificação de Risco */}
                                <div className="risk-classification">
                                    <h3>Classificação de Risco</h3>
                                    <div className="risk-options">
                                        {riskLevels.map(level => (
                                            <button
                                                key={level.value}
                                                type="button"
                                                className={`risk-option ${classification === level.value ? "selected" : ""}`}
                                                style={{ 
                                                    borderColor: classification === level.value ? level.color : "transparent",
                                                    background: classification === level.value ? `${level.color}20` : "white"
                                                }}
                                                onClick={() => setClassification(level.value)}
                                            >
                                                <span className="risk-icon">{level.icon}</span>
                                                <span className="risk-label" style={{ color: level.color }}>
                                                    {level.label}
                                                </span>
                                            </button>
                                        ))}
                                    </div>
                                </div>

                                {/* Observações */}
                                <div className="observations">
                                    <h3>Observações</h3>
                                    <textarea
                                        value={observations}
                                        onChange={(e) => setObservations(e.target.value)}
                                        placeholder="Digite observações sobre o paciente..."
                                        rows={3}
                                    />
                                </div>

                                {/* Ações */}
                                <div className="triage-actions">
                                    <button 
                                        onClick={handleFinishTriage}
                                        disabled={loading || !classification}
                                        className="btn-finish"
                                    >
                                        ✅ Finalizar Triagem
                                    </button>
                                    <button 
                                        onClick={handleForwardToDoctor}
                                        disabled={loading}
                                        className="btn-forward"
                                    >
                                        ➡️ Encaminhar para Médico
                                    </button>
                                </div>
                            </>
                        ) : (
                            <div className="no-patient">
                                <p>Nenhum paciente selecionado</p>
                                <p className="hint">Selecione um paciente da fila ou clique em "Chamar Próximo"</p>
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </Layout>
    );
}
