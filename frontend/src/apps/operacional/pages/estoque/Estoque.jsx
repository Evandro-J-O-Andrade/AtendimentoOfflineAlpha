/**
 * Landing Page - Estoque/Almoxarifado
 * 
 * Página inicial do setor de Estoque
 * Baseado nas tabelas do banco de dados
 */

import { useState } from "react";
import Layout from "../../layout/Layout";
import "./Estoque.css";

export default function Estoque() {
    const [activeTab, setActiveTab] = useState("produtos");

    // Dados de exemplo
    const [produtos, setProdutos] = useState([
        { id: 1, nome: "Dipirona 500mg", principio_ativo: "Dipirona Sódica", quantidade: 1000, unidade: "cp", local: "Almoxarifado A" },
        { id: 2, nome: "Soro Fisiológico 0,9%", principio_ativo: "Cloreto de Sódio", quantidade: 500, unidade: "fr", local: "Farmácia" },
        { id: 3, nome: "Paracetamol 750mg", principio_ativo: "Paracetamol", quantidade: 2000, unidade: "cp", local: "Almoxarifado A" },
    ]);

    // Campos do formulário
    const [formData, setFormData] = useState({
        nome_produto: "",
        principio_ativo: "",
        quantidade: "",
        local: "ALMOXARIFADO_A",
        tipo_movimento: "ENTRADA"
    });

    // Tabelas utilizadas
    const tabelas = [
        { nome: "estoque_produto", descricao: "Catálogo de produtos" },
        { nome: "estoque_lote", descricao: "Lotes de produtos" },
        { nome: "estoque_saldo", descricao: "Saldos em estoque" },
        { nome: "estoque_movimentacao", descricao: "Movimentações de estoque" },
        { nome: "almoxarifado_central", descricao: "Almoxarifados" }
    ];

    // SPs relacionadas
    const sps = [
        { nome: "sp_estoque_buscar", descricao: "Buscar produtos em estoque" },
        { nome: "sp_estoque_movimentar", descricao: "Movimentar estoque" },
        { nome: "sp_estoque_inventariar", descricao: "Realizar inventário" }
    ];

    // JOINs
    const joins = `SELECT ep.*, el.lote, el.quantidade as lote_qtd, el.validade
FROM estoque_produto ep
JOIN estoque_lote el ON el.id_produto = ep.id_produto
JOIN estoque_saldo es ON es.id_produto = ep.id_produto
WHERE es.quantidade > 0`;

    const handleInputChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    return (
        <Layout>
            <div className="estoque-page">
                <h1 className="page-title">📦 Estoque / Almoxarifado</h1>

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
                        className={activeTab === "produtos" ? "active" : ""} 
                        onClick={() => setActiveTab("produtos")}
                    >
                        📦 Produtos
                    </button>
                    <button 
                        className={activeTab === "movimentacao" ? "active" : ""} 
                        onClick={() => setActiveTab("movimentacao")}
                    >
                        🔄 Movimentação
                    </button>
                    <button 
                        className={activeTab === "inventario" ? "active" : ""} 
                        onClick={() => setActiveTab("inventario")}
                    >
                        📋 Inventário
                    </button>
                </div>

                {activeTab === "produtos" && (
                    <div className="tab-content">
                        <div className="card">
                            <h2>Buscar Produto</h2>
                            <div className="search-box">
                                <input 
                                    type="text" 
                                    placeholder="Buscar por nome ou princípio ativo..."
                                    className="search-input"
                                />
                                <button className="btn-search">🔍 Buscar</button>
                            </div>
                        </div>

                        <div className="card">
                            <h2>Estoque Atual</h2>
                            <table className="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Produto</th>
                                        <th>Princípio Ativo</th>
                                        <th>Qtd</th>
                                        <th>Unidade</th>
                                        <th>Local</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {produtos.map(p => (
                                        <tr key={p.id}>
                                            <td>{p.id}</td>
                                            <td>{p.nome}</td>
                                            <td>{p.principio_ativo}</td>
                                            <td>{p.quantidade}</td>
                                            <td>{p.unidade}</td>
                                            <td>{p.local}</td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </div>
                )}

                {activeTab === "movimentacao" && (
                    <div className="tab-content">
                        <div className="card">
                            <h2>Nova Movimentação</h2>
                            <form className="form-grid">
                                <div className="form-group">
                                    <label>Tipo de Movimento:</label>
                                    <select name="tipo_movimento" value={formData.tipo_movimento} onChange={handleInputChange}>
                                        <option value="ENTRADA">Entrada</option>
                                        <option value="SAIDA">Saída</option>
                                        <option name="TRANSFERENCIA">Transferência</option>
                                    </select>
                                </div>
                                <div className="form-group">
                                    <label>Produto:</label>
                                    <input 
                                        type="text" 
                                        name="nome_produto"
                                        value={formData.nome_produto}
                                        onChange={handleInputChange}
                                        placeholder="Nome do produto"
                                    />
                                </div>
                                <div className="form-group">
                                    <label>Quantidade:</label>
                                    <input 
                                        type="number" 
                                        name="quantidade"
                                        value={formData.quantidade}
                                        onChange={handleInputChange}
                                        placeholder="0"
                                    />
                                </div>
                                <div className="form-group">
                                    <label>Local:</label>
                                    <select name="local" value={formData.local} onChange={handleInputChange}>
                                        <option value="ALMOXARIFADO_A">Almoxarifado A</option>
                                        <option value="ALMOXARIFADO_B">Almoxarifado B</option>
                                        <option value="FARMACIA">Farmácia</option>
                                    </select>
                                </div>
                                <button type="submit" className="btn-primary">
                                    ➕ Registrar Movimentação
                                </button>
                            </form>
                        </div>
                    </div>
                )}

                {activeTab === "inventario" && (
                    <div className="tab-content">
                        <div className="card">
                            <h2>Inventário</h2>
                            <p>Funcionalidade de inventário em desenvolvimento...</p>
                        </div>
                    </div>
                )}
            </div>
        </Layout>
    );
}
