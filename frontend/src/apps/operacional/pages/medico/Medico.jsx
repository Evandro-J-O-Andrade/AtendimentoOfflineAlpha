import { useEffect, useState } from "react";
import { useAuth } from "../../../../context/AuthProvider";
import Layout from "../../layout/Layout";
import PatientQueue from "../../components/PatientQueue";
import spApi from "../../../../api/spApi";
import { finalizarAtendimento, iniciarAtendimento, registrarPrescricao, salvarEvolucao } from "../../../../services/AssistencialService";
import { chamarProximo } from "../../../../services/FilaService";
import Timeline from "./Timeline";
import "./Medico.css";

export default function Medico() {
    const { session } = useAuth();
    const [selectedPatient, setSelectedPatient] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");
    const [timeline, setTimeline] = useState(null);

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

    const idSessao = session?.id_sessao;

    useEffect(() => {
        async function carregarTimeline() {
            if (!idSessao || !selectedPatient?.id_ffa) {
                setTimeline(null);
                return;
            }

            try {
                const resposta = await spApi.call('sp_consultar_timeline_paciente', {
                    p_id_sessao: idSessao,
                    p_id_ffa: selectedPatient.id_ffa
                });
                setTimeline(resposta);
            } catch (e) {
                console.error('Erro ao carregar timeline:', e);
            }
        }

        carregarTimeline();
    }, [idSessao, selectedPatient]);

    // Chamar próximo paciente da fila automaticamente
    async function handleCallNext() {
        setLoading(true);
        setError("");

        try {
            if (!idSessao) {
                setError("Sessão não encontrada");
                return;
            }

            // Chamar próximo paciente da fila
            const chamada = await chamarProximo(idSessao, null);
            
            if (!chamada.ok) {
                setError(chamada.erro || "Erro ao chamar próximo paciente");
                return;
            }

            // Obter o paciente chamado
            const pacienteChamado = chamada.data || chamada.resultado;
            
            if (pacienteChamado) {
                // Selecionar automaticamente o paciente
                setSelectedPatient({
                    ...pacienteChamado,
                    id: pacienteChamado.id_ffa || pacienteChamado.id,
                    nome_paciente: pacienteChamado.nome_paciente || pacienteChamado.paciente,
                    senha: pacienteChamado.senha
                });
                
                // Iniciar atendimento automaticamente
                const inicio = await iniciarAtendimento(idSessao, pacienteChamado.id_ffa || pacienteChamado.id);
                if (inicio.ok) {
                    setSuccess(`Paciente ${pacienteChamado.nome_paciente || pacienteChamado.paciente} chamado e atendimento iniciado!`);
                } else {
                    setSuccess(`Paciente ${pacienteChamado.nome_paciente || pacienteChamado.paciente} chamado!`);
                }
            } else {
                setError("Nenhum paciente na fila para atendimento");
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
            const idFfa = selectedPatient.id_ffa || selectedPatient.id;
            const evolucaoPayload = {
                id_ffa: idFfa,
                queixa_principal: complaint,
                diagnostico: diagnosis,
                conduta: conduct,
                solicitacao_exame: examRequest,
                observacao: diagnosis,
                id_unidade: session?.id_unidade,
                id_saas_entidade: 1,
                device_info: 'frontend-medico'
            };

            const evolucao = await salvarEvolucao(idSessao, evolucaoPayload);
            if (!evolucao.ok) {
                setError(evolucao.erro || "Erro ao salvar evolução");
                return;
            }

            if (prescription) {
                await registrarPrescricao(idSessao, {
                    id_ffa: idFfa,
                    prescricao: prescription,
                    conduta: conduct
                });
            }

            const data = await finalizarAtendimento(idSessao, idFfa);

            if (data.ok) {
                setSuccess("Atendimento finalizado com sucesso!");
                setSelectedPatient(null);
                setTimeline(null);
                resetForm();
            } else {
                setError(data.erro || "Erro ao finalizar atendimento");
            }
        } catch {
            setError("Erro ao finalizar atendimento");
        } finally {
            setLoading(false);
        }
    }

    // Encaminhar paciente para outro setor
    async function handleForward(destination) {
        if (!selectedPatient || !idSessao) {
            setError("Nenhum paciente selecionado");
            return;
        }

        setLoading(true);
        setError("");

        try {
            const idFfa = selectedPatient.id_ffa || selectedPatient.id;
            
            await spApi.call('sp_encaminhar_paciente', {
                p_id_sessao: idSessao,
                p_id_ffa: idFfa,
                p_destino: destination,
                p_id_unidade: session?.id_unidade
            });

            setSuccess(`Pacienteencaminhado para ${destination} com sucesso!`);
            setSelectedPatient(null);
            setTimeline(null);
            resetForm();
        } catch {
            setError("Erro de comunicação");
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

                                {timeline && (
                                    <div className="form-section history-panel">
                                        <h3>Histórico / Resumo Clínico</h3>
                                        <div className="history-box">
                                            <p><strong>Status Atual:</strong> {timeline.status_atual || '-'}</p>
                                            <p><strong>Abertura:</strong> {timeline.abertura_ficha || '-'}</p>
                                            <p><strong>Triagem:</strong> {timeline.triagem?.queixa || timeline.triagem?.classificacao || '-'}</p>
                                        </div>
                                        <Timeline eventos={timeline.eventos || []} />
                                    </div>
                                )}

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
