import { useState, useEffect } from "react";
import "./Painel.css";

export default function Painel() {
    const [queue, setQueue] = useState([]);
    const [currentTime, setCurrentTime] = useState(new Date());
    const [loading, setLoading] = useState(true);

    // Atualiza o relógio
    useEffect(() => {
        const timer = setInterval(() => setCurrentTime(new Date()), 1000);
        return () => clearInterval(timer);
    }, []);

    // Busca dados do painel (sem autenticação para display público)
    useEffect(() => {
        fetchQueue();
        const interval = setInterval(fetchQueue, 5000);
        return () => clearInterval(interval);
    }, []);

    async function fetchQueue() {
        try {
            const res = await fetch("/api/painel/painel");
            const data = await res.json();
            
            if (res.ok) {
                setQueue(data.fila || []);
            }
        } catch (e) {
            console.log("Erro ao carregar painel:", e);
        } finally {
            setLoading(false);
        }
    }

    return (
        <div className="painel-container">
            <header className="painel-header">
                <div className="painel-logo">
                    <img src="/assets/img/logosenfundo.png" alt="Logo" />
                    <h1>PRONTO ATENDIMENTO</h1>
                </div>
                <div className="painel-clock">
                    <span className="clock-date">{currentTime.toLocaleDateString("pt-BR")}</span>
                    <span className="clock-time">{currentTime.toLocaleTimeString("pt-BR")}</span>
                </div>
            </header>

            <main className="painel-content">
                {loading ? (
                    <div className="painel-loading">
                        <span className="spinner"></span>
                        Carregando...
                    </div>
                ) : (
                    <>
                        {/* Chamado Atual */}
                        <section className="current-call">
                            <h2>ATUALMENTE</h2>
                            {queue.filter(p => p.status === "EM_ATENDIMENTO").length > 0 ? (
                                <div className="call-cards">
                                    {queue.filter(p => p.status === "EM_ATENDIMENTO").map((patient) => (
                                        <div key={patient.id} className="call-card">
                                            <span className="call-ticket">{patient.senha}</span>
                                            <span className="call-location">{patient.local_chamada}</span>
                                        </div>
                                    ))}
                                </div>
                            ) : (
                                <div className="no-call">Aguardando chamada...</div>
                            )}
                        </section>

                        {/* Fila de Espera */}
                        <section className="waiting-queue">
                            <h2>AGUARDANDO</h2>
                            <div className="queue-grid">
                                {queue.filter(p => p.status === "AGUARDANDO").map((patient) => (
                                    <div key={patient.id} className={`queue-card priority-${patient.prioridade || 3}`}>
                                        <span className="queue-ticket">{patient.senha}</span>
                                        <span className="queue-name">{patient.nome_paciente?.substring(0, 20) || "---"}</span>
                                    </div>
                                ))}
                                {queue.filter(p => p.status === "AGUARDANDO").length === 0 && (
                                    <div className="queue-empty">Sem pacientes aguardando</div>
                                )}
                            </div>
                        </section>
                    </>
                )}
            </main>

            <footer className="painel-footer">
                <p>Sistema de Gestão de Pronto Atendimento - Alpha</p>
            </footer>
        </div>
    );
}
