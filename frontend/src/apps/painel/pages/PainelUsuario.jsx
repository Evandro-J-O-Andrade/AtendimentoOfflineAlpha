import { useState, useEffect } from "react";
import { useRuntimeAuth } from "../../operacional/auth/RuntimeAuthContext";
import "./PainelUsuario.css";

export default function PainelUsuario() {
    const { session, authFetch } = useRuntimeAuth();
    const [pacientes, setPacientes] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        async function fetchDados() {
            try {
                const res = await authFetch("/api/painel/painel");
                if (res.ok) {
                    const data = await res.json();
                    setPacientes(data.pacientes || []);
                }
            } catch (err) {
                console.error("Erro ao buscar dados:", err);
            } finally {
                setLoading(false);
            }
        }

        if (session?.token) {
            fetchDados();
        }
    }, [session, authFetch]);

    if (loading) {
        return <div className="painel-loading">Carregando painel...</div>;
    }

    return (
        <div className="painel-container">
            <header className="painel-header">
                <h1>🏥 Painel do Usuário</h1>
                <div className="painel-info">
                    <span>Perfil: {session?.user?.perfil}</span>
                    <span>Unidade: {session?.user?.id_unidade || "Não definida"}</span>
                </div>
            </header>

            <main className="painel-main">
                <div className="painel-stats">
                    <div className="stat-card">
                        <span className="stat-icon">👥</span>
                        <span className="stat-value">{pacientes.length}</span>
                        <span className="stat-label">Pacientes em Espera</span>
                    </div>
                </div>

                <div className="painel-section">
                    <h2>Fila de Atendimentos</h2>
                    <div className="painel-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>Ordem</th>
                                    <th>Paciente</th>
                                    <th>Status</th>
                                    <th>Entrada</th>
                                </tr>
                            </thead>
                            <tbody>
                                {pacientes.length > 0 ? (
                                    pacientes.map((p, idx) => (
                                        <tr key={idx}>
                                            <td>{idx + 1}</td>
                                            <td>{p.nome}</td>
                                            <td>{p.status}</td>
                                            <td>{p.entrada}</td>
                                        </tr>
                                    ))
                                ) : (
                                    <tr>
                                        <td colSpan="4" style={{textAlign: "center"}}>
                                            Nenhum paciente em espera
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    );
}
