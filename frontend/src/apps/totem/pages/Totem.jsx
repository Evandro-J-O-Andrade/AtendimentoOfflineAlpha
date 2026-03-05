import { useState } from "react";
import "./Totem.css";

export default function Totem() {
    const [step, setStep] = useState("welcome"); // welcome, type, success
    const [, setTicketType] = useState(null);
    const [ticket, setTicket] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");

    // Gerar senha
    async function handleGenerateTicket(type) {
        setLoading(true);
        setError("");
        setTicketType(type);

        try {
            const res = await fetch("/api/totem/senhas", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ tipo: type })
            });

            const data = await res.json();

            if (res.ok) {
                setTicket(data.senha);
                setStep("success");
            } else {
                setError(data.error || "Erro ao gerar senha");
            }
        } catch {
            setError("Erro de comunicação");
        } finally {
            setLoading(false);
        }
    }

    // Voltar ao início
    function handleReset() {
        setStep("welcome");
        setTicketType(null);
        setTicket(null);
        setError("");
    }

    return (
        <div className="totem-container">
            <header className="totem-header">
                <img src="/assets/img/logosenfundo.png" alt="Logo" className="totem-logo" />
                <h1>PRONTO ATENDIMENTO</h1>
            </header>

            <main className="totem-content">
                {error && (
                    <div className="totem-error">
                        {error}
                        <button onClick={handleReset}>Tentar novamente</button>
                    </div>
                )}

                {/* Welcome Screen */}
                {step === "welcome" && (
                    <div className="welcome-screen">
                        <h2>BEM-VINDO</h2>
                        <p>Selecione o tipo de atendimento:</p>
                        
                        <div className="type-options">
                            <button 
                                onClick={() => handleGenerateTicket("CONSULTA")}
                                disabled={loading}
                                className="type-btn consulta"
                            >
                                <span className="type-icon">👨‍⚕️</span>
                                <span className="type-label">Consulta</span>
                            </button>
                            
                            <button 
                                onClick={() => handleGenerateTicket("URGENCIA")}
                                disabled={loading}
                                className="type-btn urgencia"
                            >
                                <span className="type-icon">🚨</span>
                                <span className="type-label">Urgência</span>
                            </button>
                            
                            <button 
                                onClick={() => handleGenerateTicket("EXAME")}
                                disabled={loading}
                                className="type-btn exame"
                            >
                                <span className="type-icon">🧪</span>
                                <span className="type-label">Exame</span>
                            </button>
                        </div>

                        {loading && (
                            <div className="loading-indicator">
                                <span className="spinner"></span>
                                Gerando senha...
                            </div>
                        )}
                    </div>
                )}

                {/* Success Screen */}
                {step === "success" && (
                    <div className="success-screen">
                        <h2>SUA SENHA</h2>
                        
                        <div className="ticket-display">
                            <span className="ticket-code">{ticket?.codigo}</span>
                            <span className="ticket-type-label">{ticket?.tipo}</span>
                        </div>

                        <div className="ticket-info">
                            <p>Aguarde ser chamado</p>
                            <p className="ticket-hint">Compareça ao balção quando sua senha for exibida</p>
                        </div>

                        <button onClick={handleReset} className="btn-new-ticket">
                            Obter nova senha
                        </button>
                    </div>
                )}
            </main>

            <footer className="totem-footer">
                <p>Emitido em: {new Date().toLocaleString("pt-BR")}</p>
            </footer>
        </div>
    );
}
