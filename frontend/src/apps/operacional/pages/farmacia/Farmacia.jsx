import { useState, useEffect } from "react";
import { useRuntimeAuth } from "../../auth/RuntimeAuthContext";
import Layout from "../../layout/Layout";
import "./Farmacia.css";

export default function Farmacia() {
    const { authFetch } = useRuntimeAuth();
    const [searchTerm, setSearchTerm] = useState("");
    const [prescription, setPrescription] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");
    const [dispendedItems, setDispendedItems] = useState([]);
    const [history, setHistory] = useState([]);

    // Carregar histórico ao iniciar
    useEffect(() => {
        loadHistory();
    }, []);

    // Carregar histórico de dispensação
    async function loadHistory() {
        try {
            const res = await authFetch(`/api/operacional/farmacia/historico`);
            const data = await res.json();
            
            if (res.ok && data.historico) {
                setHistory(data.historico);
            }
        } catch {
            // Silencioso - histórico é secundário
        }
    }

    // Buscar prescrição
    async function handleSearch(e) {
        e.preventDefault();
        if (!searchTerm.trim()) return;

        setLoading(true);
        setError("");
        setPrescription(null);
        setDispendedItems([]);

        try {
            const res = await authFetch(`/api/operacional/farmacia/buscar?termo=${encodeURIComponent(searchTerm)}`);
            const data = await res.json();

            if (res.ok && data.prescricoes && data.prescricoes.length > 0) {
                setPrescription(data.prescricoes[0]);
            } else {
                setError("Nenhuma prescrição encontrada para este termo");
            }
        } catch {
            setError("Erro ao buscar prescrição");
        } finally {
            setLoading(false);
        }
    }

    // Dispensar medicamento
    async function handleDispense(item) {
        setLoading(true);
        setError("");

        try {
            const res = await authFetch("/api/operacional/farmacia/dispensar", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    id_prescricao_item: item.id,
                    lote: item.lote
                })
            });

            const data = await res.json();

            if (res.ok) {
                setDispendedItems(prev => [...prev, item.id]);
                setSuccess(`${item.medicamento} dispensado com sucesso!`);
            } else {
                setError(data.error || "Erro ao dispensar");
            }
        } catch {
            setError("Erro ao dispensar");
        } finally {
            setLoading(false);
        }
    }

    // Finalizar dispensação
    async function handleFinish() {
        setLoading(true);
        setError("");

        try {
            const res = await authFetch(`/api/operacional/farmacia/${prescription.id}/finalizar`, {
                method: "POST",
                headers: { "Content-Type": "application/json" }
            });

            const data = await res.json();

            if (res.ok) {
                setSuccess("Dispensação finalizada!");
                setPrescription(null);
                setSearchTerm("");
                setDispendedItems([]);
            } else {
                setError(data.error || "Erro ao finalizar");
            }
        } catch {
            setError("Erro ao finalizar");
        } finally {
            setLoading(false);
        }
    }

    return (
        <Layout>
            <div className="farmacia-page">
                <h1 className="page-title">💊 Farmácia</h1>

                <div className="farmacia-grid">
                    {/* Busca de Prescrição */}
                    <div className="card search-card">
                        <h2>🔍 Buscar Prescrição</h2>
                        
                        <form onSubmit={handleSearch} className="search-form">
                            <input
                                type="text"
                                placeholder="Número da senha ou nome do paciente"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="search-input"
                            />
                            <button type="submit" disabled={loading} className="btn-search">
                                {loading ? "Buscando..." : "Buscar"}
                            </button>
                        </form>

                        {error && <div className="alert alert-error">{error}</div>}
                        {success && <div className="alert alert-success">{success}</div>}
                    </div>

                    {/* Prescrição */}
                    {prescription && (
                        <div className="card prescription-card">
                            <h2>📋 Prescrição</h2>
                            
                            <div className="prescription-header">
                                <div className="patient-info">
                                    <p><strong>Paciente:</strong> {prescription.nome_paciente}</p>
                                    <p><strong>Senha:</strong> {prescription.senha}</p>
                                    <p><strong>Médico:</strong> {prescription.nome_medico}</p>
                                </div>
                            </div>

                            <div className="prescription-items">
                                <h3>Medicamentos</h3>
                                {prescription.itens && prescription.itens.map((item, index) => (
                                    <div key={index} className={`prescription-item ${dispendedItems.includes(item.id) ? "dispended" : ""}`}>
                                        <div className="item-info">
                                            <span className="item-name">{item.medicamento}</span>
                                            <span className="item-dosage">{item.dosagem}</span>
                                            <span className="item-frequency">{item.frequencia}</span>
                                        </div>
                                        
                                        {item.lote && !dispendedItems.includes(item.id) && (
                                            <div className="item-dispense">
                                                <input
                                                    type="text"
                                                    placeholder="Lote"
                                                    value={item.lote || ""}
                                                    onChange={(e) => {
                                                        const newItens = [...prescription.itens];
                                                        newItens[index].lote = e.target.value;
                                                        setPrescription({ ...prescription, itens: newItens });
                                                    }}
                                                    className="lote-input"
                                                />
                                                <button
                                                    onClick={() => handleDispense(item)}
                                                    disabled={loading || !item.lote}
                                                    className="btn-dispense"
                                                >
                                                    Dispensar
                                                </button>
                                            </div>
                                        )}
                                        
                                        {dispendedItems.includes(item.id) && (
                                            <span className="dispended-badge">✓ Dispensado</span>
                                        )}
                                    </div>
                                ))}
                            </div>

                            <button
                                onClick={handleFinish}
                                disabled={loading || dispendedItems.length === 0}
                                className="btn-finish"
                            >
                                ✅ Finalizar Dispensação
                            </button>
                        </div>
                    )}

                    {/* Histórico de Dispensação */}
                    <div className="card history-card">
                        <h2>📜 Histórico Recente</h2>
                        <div className="history-list">
                            {history && history.length > 0 ? (
                                history.map((item, index) => (
                                    <div key={index} className="history-item">
                                        <div className="history-item-header">
                                            <span className="history-senha">Senha: {item.senha}</span>
                                            <span className="history-date">{new Date(item.criado_em).toLocaleString('pt-BR')}</span>
                                        </div>
                                        <div className="history-item-body">
                                            <span className="history-medicamento">{item.nome_medicamento}</span>
                                            <span className="history-quantidade">Qtd: {item.quantidade}</span>
                                            {item.lote && <span className="history-lote">Lote: {item.lote}</span>}
                                        </div>
                                        <div className="history-patient">
                                            Paciente: {item.nome_paciente}
                                        </div>
                                    </div>
                                ))
                            ) : (
                                <p className="empty-message">Nenhuma dispensação recente</p>
                            )}
                        </div>
                    </div>
                </div>
            </div>
        </Layout>
    );
}
