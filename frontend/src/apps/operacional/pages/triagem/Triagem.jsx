import { useState } from "react";
import { useAuth } from "../../../../context/AuthProvider";
import Layout from "../../layout/Layout";
import PatientQueue from "../../components/PatientQueue";
import spApi from "../../../../api/spApi";
import { iniciarTriagem, salvarTriagem, finalizarTriagem } from "../../../../services/AssistencialService";
import "./Triagem.css";

export default function Triagem() {
    const { session } = useAuth();
    const idSessao = session?.id_sessao;
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
    const [chiefComplaint, setChiefComplaint] = useState("");
    const [painScale, setPainScale] = useState("");

    // Atualiza sinais vitais
    function handleVitalChange(field, value) {
        setVitalSigns(prev => ({ ...prev, [field]: value }));
    }

    // Chamar próximo paciente
    async function handleCallNext() {
        setLoading(true);
        setError("");
        
        try {
            if (!idSessao || !selectedPatient?.id_ffa) {
                setError("Selecione um paciente da fila para iniciar a triagem");
            } else {
                const data = await iniciarTriagem(idSessao, selectedPatient.id_ffa);
                if (data.ok) {
                    setSuccess("Triagem iniciada com sucesso!");
                } else {
                    setError(data.mensagem || "Erro ao iniciar triagem");
                }
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
            const payloadTriagem = {
                ...vitalSigns,
                classificacao_risco: classification,
                prioridade_cor: classification,
                observacoes_triagem: observations,
                queixa_principal: chiefComplaint,
                escala_dor: painScale,
                id_unidade: session?.id_unidade
            };

            const salvar = await salvarTriagem(idSessao, selectedPatient.id_ffa || selectedPatient.id, payloadTriagem);
            if (!salvar.ok) {
                setError(salvar.mensagem || "Erro ao salvar triagem");
                return;
            }

            const data = await finalizarTriagem(idSessao, selectedPatient.id_ffa || selectedPatient.id, payloadTriagem);

            if (data.ok) {
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
                setChiefComplaint("");
                setPainScale("");
            } else {
                setError(data.mensagem || "Erro ao finalizar triagem");
            }
        } catch {
            setError("Erro ao finalizar triagem");
        } finally {
            setLoading(false);
        }
    }

    // Encaminhar para médico
    async function handleForwardToDoctor() {
        if (!selectedPatient || !idSessao) {
            setError("Nenhum paciente selecionado");
            return;
        }

        setLoading(true);
        setError("");

        try {
            const idFfa = selectedPatient.id_ffa || selectedPatient.id;
            
            // Primeiro finalizar a triagem se ainda não finalizada
            const payloadTriagem = {
                ...vitalSigns,
                classificacao_risco: classification,
                prioridade_cor: classification,
                observacoes_triagem: observations,
                queixa_principal: chiefComplaint,
                escala_dor: painScale,
                id_unidade: session?.id_unidade
            };

            // Salvar triagem
            const salvar = await salvarTriagem(idSessao, idFfa, payloadTriagem);
            if (!salvar.ok) {
                setError(salvar.erro || "Erro ao salvar triagem");
                return;
            }

            // Encaminhar para médico usando o fluxo assistencial
            await spApi.call('sp_triagem_encaminhar_medico', {
                p_id_sessao: idSessao,
                p_id_ffa: idFfa,
                p_id_unidade: session?.id_unidade
            });

            setSuccess("Pacienteencaminhado para médico com sucesso!");
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
            setChiefComplaint("");
            setPainScale("");
        } catch (e) {
            setError(e.message || "Erro de comunicação");
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
                                        <div className="vital-input">
                                            <label>Peso</label>
                                            <input 
                                                type="number" 
                                                step="0.1"
                                                value={vitalSigns.peso}
                                                onChange={(e) => handleVitalChange("peso", e.target.value)}
                                                placeholder="70"
                                            />
                                            <span className="unit">kg</span>
                                        </div>
                                        <div className="vital-input">
                                            <label>Altura</label>
                                            <input 
                                                type="number" 
                                                step="0.01"
                                                value={vitalSigns.altura}
                                                onChange={(e) => handleVitalChange("altura", e.target.value)}
                                                placeholder="1.70"
                                            />
                                            <span className="unit">m</span>
                                        </div>
                                        <div className="vital-input">
                                            <label>HGT</label>
                                            <input 
                                                type="number" 
                                                value={vitalSigns.hgt || ""}
                                                onChange={(e) => handleVitalChange("hgt", e.target.value)}
                                                placeholder="95"
                                            />
                                            <span className="unit">mg/dL</span>
                                        </div>
                                    </div>
                                </div>

                                <div className="triage-clinical-data">
                                    <div className="field-block">
                                        <h3>Queixa Principal</h3>
                                        <textarea
                                            value={chiefComplaint}
                                            onChange={(e) => setChiefComplaint(e.target.value)}
                                            placeholder="Descreva a queixa principal do paciente..."
                                            rows={3}
                                        />
                                    </div>
                                    <div className="field-block">
                                        <h3>Escala de Dor</h3>
                                        <input
                                            type="number"
                                            min="0"
                                            max="10"
                                            value={painScale}
                                            onChange={(e) => setPainScale(e.target.value)}
                                            placeholder="0 a 10"
                                        />
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
