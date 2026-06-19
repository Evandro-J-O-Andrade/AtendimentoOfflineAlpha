import { useState, useEffect } from "react";
import { useAuth } from "../../../context/AuthProvider";
import spApi from "../../../api/spApi";
import "./PainelUsuario.css";

export default function PainelUsuario() {
    const { sessao, contexto } = useAuth();
    const [pacientes, setPacientes] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        async function fetchDados() {
            try {
                const data = await spApi.call('sp_painel_pacientes', {
                    p_id_sessao: sessao?.id_sessao_usuario
                });
                setPacientes(Array.isArray(data) ? data : []);
            } catch (err) {
                console.error("Erro ao buscar dados:", err);
            } finally {
                setLoading(false);
            }
        }

        if (sessao?.id_sessao_usuario) {
            fetchDados();
        }
    }, [sessao]);

    if (loading) {
        return <div className="painel-loading">Carregando painel...</div>;
    }

    return (
        <div className="painel-container">
            <header className="painel-header">
                <h1>🏥 Painel do Usuário</h1>
                <div className="painel-info">
                    <span>Perfil: {contexto?.perfil}</span>
                    <span>Unidade: {contexto?.id_unidade || "Não definida"}</span>
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
