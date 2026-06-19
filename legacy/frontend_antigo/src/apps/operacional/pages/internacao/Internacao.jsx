/**
 * Landing Page - Internação
 * 
 * Página inicial do setor de Internação
 * Baseado nas tabelas do banco de dados
 */

import { useState } from "react";
import Layout from "../../layout/Layout";
import "./Internacao.css";

export default function Internacao() {
    const [activeTab, setActiveTab] = useState("leitos");

    // Dados de exemplo
    const [leitos, setLeitos] = useState([
        { id: 1, numero: "101-A", andar: "1º Andar", unidade: "Enfermaria", status: "OCUPADO", paciente: "João Silva" },
        { id: 2, numero: "101-B", andar: "1º Andar", unidade: "Enfermaria", status: "LIVRE", paciente: "-" },
        { id: 3, numero: "102-A", andar: "1º Andar", unidade: "UTI", status: "OCUPADO", paciente: "Maria Santos" },
        { id: 4, numero: "102-B", andar: "1º Andar", unidade: "UTI", status: "LIMPEZA", paciente: "-" },
    ]);

    // Campos do formulário de internação
    const [formData, setFormData] = useState({
        id_paciente: "",
        quarto: "",
        unidade: "ENFERMARIA",
        motivo: "",
        medico_responsavel: ""
    });

    // Tabelas utilizadas
    const tabelas = [
        { nome: "internacao", descricao: "Registro de internações" },
        { nome: "leito", descricao: "Catálogo de leitos" },
        { nome: "hospital_leitos", descricao: "Leitos do hospital" },
        { nome: "internacao_prescricao", descricao: "Prescrições de internação" },
        { nome: "internacao_movimentacao", descricao: "Movimentação do paciente" }
    ];

    // SPs relacionadas
    const sps = [
        { nome: "sp_internacao_iniciar", descricao: "Iniciar internação" },
        { nome: "sp_internacao_alta", descricao: "Dar alta ao paciente" },
        { nome: "sp_leito_alocar", descricao: "Alocar paciente em leito" }
    ];

    // JOINs
    const joins = `SELECT i.*, pes.nome_completo, l.numero as leito_numero, un.nome as unidade_nome
FROM internacao i
JOIN paciente pac ON pac.id = i.id_paciente
JOIN pessoa pes ON pes.id_pessoa = pac.id_pessoa
JOIN leito l ON l.id_leito = i.id_leito
JOIN unidade un ON un.id_unidade = i.id_unidade
WHERE i.status = 'ATIVA'`;

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    return (
        <Layout>
            <div className="internacao-page">
                <h1 className="page-title">🛏️ Internação</h1>

                {/* Info Técnica */}
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

                {/* Abas */}
                <div className="tabs">
                    <button 
                        className={activeTab === "leitos" ? "active" : ""} 
                        onClick={() => setActiveTab("leitos")}
                    >
                        🛏️ Leitos
                    </button>
                    <button 
                        className={activeTab === "internacoes" ? "active" : ""} 
                        onClick={() => setActiveTab("internacoes")}
                    >
                        📋 Internações
                    </button>
                    <button 
                        className={activeTab === "movimentacao" ? "active" : ""} 
                        onClick={() => setActiveTab("movimentacao")}
                    >
                        🔄 Movimentação
                    </button>
                </div>

                {activeTab === "leitos" && (
                    <div className="tab-content">
                        <div className="card">
                            <h2>Mapa de Leitos</h2>
                            <div className="leitos-grid">
                                {leitos.map(leito => (
                                    <div key={leito.id} className={`leito-card ${leito.status.toLowerCase()}`}>
                                        <div className="leito-numero">{leito.numero}</div>
                                        <div className="leito-unidade">{leito.unidade}</div>
                                        <div className="leito-paciente">{leito.paciente}</div>
                                        <span className="leito-status">{leito.status}</span>
                                    </div>
                                ))}
                            </div>
                        </div>
                    </div>
                )}

                {activeTab === "internacoes" && (
                    <div className="tab-content">
                        <div className="card">
                            <h2>Nova Internação</h2>
                            <form className="form-grid">
                                <div className="form-group">
                                    <label>ID Paciente:</label>
                                    <input 
                                        type="text" 
                                        name="id_paciente"
                                        value={formData.id_paciente}
                                        onChange={handleInputChange}
                                        placeholder="Digite o ID"
                                    />
                                </div>
                                <div className="form-group">
                                    <label>Quarto/Leito:</label>
                                    <select name="quarto" value={formData.quarto} onChange={handleInputChange}>
                                        <option value="">Selecione...</option>
                                        <option value="101-A">101-A</option>
                                        <option value="101-B">101-B</option>
                                        <option value="102-A">102-A</option>
                                    </select>
                                </div>
                                <div className="form-group">
                                    <label>Unidade:</label>
                                    <select name="unidade" value={formData.unidade} onChange={handleInputChange}>
                                        <option value="ENFERMARIA">Enfermaria</option>
                                        <option value="UTI">UTI</option>
                                        <option value="PEDIATRIA">Pediatria</option>
                                    </select>
                                </div>
                                <div className="form-group">
                                    <label>Médico Responsável:</label>
                                    <input 
                                        type="text" 
                                        name="medico_responsavel"
                                        value={formData.medico_responsavel}
                                        onChange={handleInputChange}
                                        placeholder="Nome do médico"
                                    />
                                </div>
                                <div className="form-group" style={{ gridColumn: "1 / -1" }}>
                                    <label>Motivo da Internação:</label>
                                    <textarea 
                                        name="motivo"
                                        value={formData.motivo}
                                        onChange={handleInputChange}
                                        rows="3"
                                    />
                                </div>
                                <button type="submit" className="btn-primary">
                                    ➕ Internar Paciente
                                </button>
                            </form>
                        </div>
                    </div>
                )}

                {activeTab === "movimentacao" && (
                    <div className="tab-content">
                        <div className="card">
                            <h2>Movimentação de Pacientes</h2>
                            <p>Aguardando dados...</p>
                        </div>
                    </div>
                )}
            </div>
        </Layout>
    );
}
