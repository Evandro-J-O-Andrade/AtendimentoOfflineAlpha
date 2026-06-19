/**
 * Landing Page - Laboratório
 * 
 * Página inicial do setor de Laboratório
 * Baseado nas tabelas do banco de dados
 */

import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Layout from "../../layout/Layout";
import "./Laboratorio.css";

export default function Laboratorio() {
    const navigate = useNavigate();
    const [activeTab, setActiveTab] = useState("pedidos");

    // Dados de exemplo para pedidos de laboratório
    const [pedidos, setPedidos] = useState([
        { id: 1, paciente: "João Silva", cpf: "123.456.789-00", exame: "Hemograma", data: "17/03/2026", status: "PENDENTE" },
        { id: 2, paciente: "Maria Santos", cpf: "987.654.321-00", exame: "Glicemia", data: "17/03/2026", status: "COLETADO" },
    ]);

    // Campos do formulário de pedido de exame
    const [formData, setFormData] = useState({
        id_paciente: "",
        tipo_exame: "",
        observacao: "",
        prioridade: "ROUTINE"
    });

    // Tabelas utilizadas nesta página (do banco)
    const tabelas = [
        { nome: "lab_pedido", descricao: "Pedidos de exames laboratoriais" },
        { nome: "lab_amostra", descricao: "Amostras coletadas" },
        { nome: "lab_resultado", descricao: "Resultados dos exames" },
        { nome: "exame_pedido", descricao: "Pedidos de exame" },
        { nome: "exame", descricao: "Catálogo de exames disponíveis" }
    ];

    // SPs relacionadas
    const sps = [
        { nome: "sp_lab_pedido_criar", descricao: "Criar novo pedido de exame" },
        { nome: "sp_lab_resultado_registrar", descricao: "Registrar resultado de exame" },
        { nome: "sp_lab_amostra_collect", descricao: "Registrar coleta de amostra" }
    ];

    // JOINs necessários para buscar pedidos
    const joins = `SELECT lp.*, pes.nome_completo, pes.cpf, e.nome as exame_nome
FROM lab_pedido lp
JOIN paciente pac ON pac.id = lp.id_paciente
JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
JOIN exame e ON e.id_exame = lp.id_exame
WHERE lp.status = 'PENDENTE'`;

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    return (
        <Layout>
            <div className="laboratorio-page">
                <h1 className="page-title">🔬 Laboratório</h1>

                {/* Info Técnica -的可 Collapsible */}
                <details className="info-tecnica">
                    <summary>🔧 Informações Técnicas (BD)</summary>
                    <div className="info-grid">
                        <div className="info-section">
                            <h4>📊 Tabelas:</h4>
                            <ul>
                                {tabelas.map(t => (
                                    <li key={t.nome}><code>{t.nome}</code> - {t.descricao}</li>
                                ))}
                            </ul>
                        </div>
                        <div className="info-section">
                            <h4>⚙️ Stored Procedures:</h4>
                            <ul>
                                {sps.map(sp => (
                                    <li key={sp.nome}><code>{sp.nome}</code> - {sp.descricao}</li>
                                ))}
                            </ul>
                        </div>
                        <div className="info-section">
                            <h4>🔗 JOINs:</h4>
                            <pre>{joins}</pre>
                        </div>
                    </div>
                </details>

                {/* Abas de navegação */}
                <div className="tabs">
                    <button 
                        className={activeTab === "pedidos" ? "active" : ""} 
                        onClick={() => setActiveTab("pedidos")}
                    >
                        📋 Pedidos
                    </button>
                    <button 
                        className={activeTab === "coleta" ? "active" : ""} 
                        onClick={() => setActiveTab("coleta")}
                    >
                        💉 Coleta
                    </button>
                    <button 
                        className={activeTab === "resultados" ? "active" : ""} 
                        onClick={() => setActiveTab("resultados")}
                    >
                        📊 Resultados
                    </button>
                </div>

                {/* Conteúdo das abas */}
                {activeTab === "pedidos" && (
                    <div className="tab-content">
                        <div className="card">
                            <h2>Novo Pedido de Exame</h2>
                            <form className="form-grid">
                                <div className="form-group">
                                    <label>ID Paciente:</label>
                                    <input 
                                        type="text" 
                                        name="id_paciente"
                                        value={formData.id_paciente}
                                        onChange={handleInputChange}
                                        placeholder="Digite o ID do paciente"
                                    />
                                </div>
                                <div className="form-group">
                                    <label>Tipo de Exame:</label>
                                    <select 
                                        name="tipo_exame"
                                        value={formData.tipo_exame}
                                        onChange={handleInputChange}
                                    >
                                        <option value="">Selecione...</option>
                                        <option value="HEMOGRAMA">Hemograma</option>
                                        <option value="GLICEMIA">Glicemia</option>
                                        <option value="URINA">EAS</option>
                                        <option value="BIOQUIMICA">Perfil Bioquímico</option>
                                    </select>
                                </div>
                                <div className="form-group">
                                    <label>Prioridade:</label>
                                    <select 
                                        name="prioridade"
                                        value={formData.prioridade}
                                        onChange={handleInputChange}
                                    >
                                        <option value="ROUTINE">Rotina</option>
                                        <option value="URGENT">Urgente</option>
                                    </select>
                                </div>
                                <div className="form-group">
                                    <label>Observação:</label>
                                    <textarea 
                                        name="observacao"
                                        value={formData.observacao}
                                        onChange={handleInputChange}
                                        rows="3"
                                        placeholder="Observações clínicas..."
                                    />
                                </div>
                                <button type="submit" className="btn-primary">
                                    ➕ Criar Pedido
                                </button>
                            </form>
                        </div>

                        <div className="card">
                            <h2>Lista de Pedidos</h2>
                            <table className="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Paciente</th>
                                        <th>CPF</th>
                                        <th>Exame</th>
                                        <th>Data</th>
                                        <th>Status</th>
                                        <th>Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {pedidos.map(pedido => (
                                        <tr key={pedido.id}>
                                            <td>{pedido.id}</td>
                                            <td>{pedido.paciente}</td>
                                            <td>{pedido.cpf}</td>
                                            <td>{pedido.exame}</td>
                                            <td>{pedido.data}</td>
                                            <td><span className={`badge ${pedido.status.toLowerCase()}`}>{pedido.status}</span></td>
                                            <td>
                                                <button className="btn-action">Ver</button>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </div>
                )}

                {activeTab === "coleta" && (
                    <div className="tab-content">
                        <div className="card">
                            <h2>Registro de Coleta</h2>
                            <p>Aguardando amostras...</p>
                        </div>
                    </div>
                )}

                {activeTab === "resultados" && (
                    <div className="tab-content">
                        <div className="card">
                            <h2>Resultados de Exames</h2>
                            <p>Aguardando resultados...</p>
                        </div>
                    </div>
                )}
            </div>
        </Layout>
    );
}
