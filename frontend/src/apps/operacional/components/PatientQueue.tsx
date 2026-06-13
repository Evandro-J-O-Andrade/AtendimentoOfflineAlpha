import { useState, useEffect } from "react";
import { useAuth } from "@/apps/operacional/auth/AuthProvider";
import { getFilaTriagem, getFilaEspera } from "@/services/FilaService";
import "./PatientQueue.css";

interface Patient {
    id: number;
    senha?: string;
    nome_paciente?: string;
    status?: string;
    prioridade?: number;
    classificacao_risco?: string;
}

interface PatientQueueProps {
    title?: string;
    status?: string;
    onSelectPatient?: (patient: Patient) => void;
    selectedPatient?: Patient | null;
    showActions?: boolean;
}

export default function PatientQueue({ 
    title = "Fila de Espera", 
    status = "AGUARDANDO",
    onSelectPatient,
    selectedPatient,
    showActions = true 
}: PatientQueueProps) {
    const { sessao } = useAuth();
    const [patients, setPatients] = useState<Patient[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    useEffect(() => {
        fetchPatients();
        const interval = setInterval(fetchPatients, 10000);
        return () => clearInterval(interval);
    }, []);

    async function fetchPatients() {
        try {
            const idSessao = sessao?.id_sessao_usuario;
            if (!idSessao) {
                setPatients([]);
                setError("Sessão operacional não encontrada");
                return;
            }

            const data = status === "AGUARDANDO_TRIAGEM"
                ? await getFilaTriagem(idSessao)
                : await getFilaEspera(idSessao);

            if (data.ok) {
                setPatients(data.resultado || data.data || []);
                setError("");
            } else {
                setError(data.erro || data.mensagem || "Erro ao carregar pacientes");
            }
        } catch {
            setError("Erro de comunicação");
        } finally {
            setLoading(false);
        }
    }

    function getStatusClass(status: string) {
        const map: Record<string, string> = {
            AGUARDANDO: "status-waiting",
            EM_ATENDIMENTO: "status-in-progress",
            ATENDIDO: "status-done",
            ENCAMINHADO: "status-forwarded",
            ALTA: "status-discharged"
        };
        return map[status] || "status-default";
    }

    function getPriorityClass(prioridade?: number) {
        const map: Record<number, string> = {
            1: "priority-emergency",
            2: "priority-urgent",
            3: "priority-normal",
            4: "priority-low",
            5: "priority-minimal"
        };
        return map[prioridade || 0] || "priority-default";
    }

    if (loading) {
        return (
            <div className="queue-container">
                <div className="queue-header">
                    <h3>{title}</h3>
                </div>
                <div className="queue-loading">
                    <span className="spinner"></span>
                    Carregando...
                </div>
            </div>
        );
    }

    return (
        <div className="queue-container">
            <div className="queue-header">
                <h3>{title}</h3>
                <span className="queue-count">{patients.length} paciente(s)</span>
            </div>

            {error && <div className="queue-error">{error}</div>}

            <div className="queue-list">
                {patients.length === 0 ? (
                    <div className="queue-empty">
                        Nenhum paciente na fila
                    </div>
                ) : (
                    patients.map(patient => (
                        <div 
                            key={patient.id}
                            className={`queue-item ${getPriorityClass(patient.prioridade)} ${selectedPatient?.id === patient.id ? "selected" : ""}`}
                            onClick={() => onSelectPatient?.(patient)}
                        >
                            <div className="patient-main">
                                <span className="patient-ticket">{patient.senha}</span>
                                <span className="patient-name">{patient.nome_paciente}</span>
                            </div>
                            <div className="patient-meta">
                                <span className={`status-badge ${getStatusClass(patient.status || '')}`}>
                                    {patient.status}
                                </span>
                                {patient.classificacao_risco && (
                                    <span className="risk-badge">
                                        {patient.classificacao_risco}
                                    </span>
                                )}
                            </div>
                            {showActions && onSelectPatient && (
                                <button 
                                    className="btn-select"
                                    onClick={(e) => {
                                        e.stopPropagation();
                                        onSelectPatient(patient);
                                    }}
                                >
                                    Selecionar
                                </button>
                            )}
                        </div>
                    ))
                )}
            </div>
        </div>
    );
}