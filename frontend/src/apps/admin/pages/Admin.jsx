import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useRuntimeAuth } from "../../operacional/auth/RuntimeAuthContext";
import "./Admin.css";

export default function Admin() {
    const { session, authFetch, logout } = useRuntimeAuth();
    const navigate = useNavigate();
    const [adminData, setAdminData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [activeSection, setActiveSection] = useState("dashboard");

    useEffect(() => {
        async function fetchAdminData() {
            try {
                const response = await authFetch("/api/painel/admin");
                
                if (response.ok) {
                    const data = await response.json();
                    setAdminData(data);
                } else {
                    setError("Erro ao carregar dados do admin");
                }
            } catch (err) {
                setError("Erro de conexão");
            } finally {
                setLoading(false);
            }
        }

        if (session?.token) {
            fetchAdminData();
        }
    }, [session, authFetch]);

    if (loading) {
        return <div className="admin-loading">Carregando painel administrativo...</div>;
    }

    if (error) {
        return <div className="admin-error">{error}</div>;
    }

    function goTo(path) {
        navigate(path);
    }

    function handleLogout() {
        logout();
        navigate("/login");
    }

    const menuItems = [
        { id: "dashboard", label: "Dashboard" },
        { id: "acesso", label: "Acesso ao Sistema" },
        { id: "operacao", label: "Fluxo Operacional" },
        { id: "cadastros", label: "Cadastros" }
    ];

    return (
        <div className="admin-container">
            <aside className="admin-sidebar">
                <div className="admin-brand">
                    <h2>Alpha Hospitalar</h2>
                    <p>Guido Guida - Poa SP</p>
                </div>

                <nav className="admin-menu">
                    {menuItems.map((item) => (
                        <button
                            key={item.id}
                            type="button"
                            className={`admin-menu-item ${activeSection === item.id ? "active" : ""}`}
                            onClick={() => setActiveSection(item.id)}
                        >
                            {item.label}
                        </button>
                    ))}
                </nav>

                <button type="button" className="admin-logout" onClick={handleLogout}>
                    Sair
                </button>
            </aside>

            <section className="admin-content">
                <header className="admin-header">
                    <h1>Sistema De atendimento Alpha Hospitalar unidade Guido Guida Poa São Paulo</h1>
                    <div className="admin-user">
                        <span>Perfil: {adminData?.usuario?.perfil}</span>
                    </div>
                </header>

                <main className="admin-main">
                    <div className="admin-cards">
                        {activeSection === "dashboard" && (
                            <>
                                <div className="admin-card">
                                    <div className="card-icon">🏥</div>
                                    <h3>Painel Administrativo</h3>
                                    <p>Visão geral de acesso, módulos e monitoramento.</p>
                                    <button className="card-button" onClick={() => goTo("/admin")}>Atualizar</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">📺</div>
                                    <h3>Painel de Chamadas</h3>
                                    <p>Exibição de senhas e fluxo de atendimento.</p>
                                    <button className="card-button" onClick={() => goTo("/painel-chamadas")}>Abrir</button>
                                </div>
                            </>
                        )}

                        {activeSection === "acesso" && (
                            <>
                                <div className="admin-card">
                                    <div className="card-icon">🔐</div>
                                    <h3>Login do Sistema</h3>
                                    <p>Fluxo principal de autenticação dos usuários.</p>
                                    <button className="card-button" onClick={() => goTo("/login")}>Entrar</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">🧭</div>
                                    <h3>Seleção de Contexto</h3>
                                    <p>Usuário médico escolhe local de atendimento antes de operar.</p>
                                    <button className="card-button" onClick={() => goTo("/contexto")}>Selecionar</button>
                                </div>
                            </>
                        )}

                        {activeSection === "operacao" && (
                            <>
                                <div className="admin-card">
                                    <div className="card-icon">🎟️</div>
                                    <h3>Totem / Senha</h3>
                                    <p>Geração de senha e início do fluxo do paciente.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/totem")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">📋</div>
                                    <h3>Recepção</h3>
                                    <p>Registro inicial e encaminhamento no atendimento.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/recepcao")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">🩺</div>
                                    <h3>Triagem</h3>
                                    <p>Classificação de risco e preparo para consulta.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/triagem")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">⚕️</div>
                                    <h3>Médico</h3>
                                    <p>Atendimento clínico, prescrição e evolução.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/medico")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">🏥</div>
                                    <h3>Enfermagem</h3>
                                    <p>Execução assistencial e acompanhamento do paciente.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/enfermagem")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">💊</div>
                                    <h3>Farmácia</h3>
                                    <p>Dispensação e controle de medicamentos.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/farmacia")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">📦</div>
                                    <h3>Estoque</h3>
                                    <p>Cadastro de lote, movimentações e produtos.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/estoque")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">🧭</div>
                                    <h3>Atendimento</h3>
                                    <p>Transições de fluxo e encerramento por evasão.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/atendimento")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">📢</div>
                                    <h3>Fila</h3>
                                    <p>Chamar próxima senha e finalizar fila operacional.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/fila")}>Abrir</button>
                                </div>
                            </>
                        )}

                        {activeSection === "cadastros" && (
                            <>
                                <div className="admin-card">
                                    <div className="card-icon">👥</div>
                                    <h3>Gestão de Usuários</h3>
                                    <p>Cadastro e manutenção de usuários e perfis.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/usuarios")}>Gerenciar</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">🏢</div>
                                    <h3>Unidades e Locais</h3>
                                    <p>Configuração de unidades e locais operacionais.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/unidades")}>Gerenciar</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">📊</div>
                                    <h3>Relatórios</h3>
                                    <p>Indicadores gerais do atendimento e gestão.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/modulo/relatorios")}>Visualizar</button>
                                </div>
                            </>
                        )}
                    </div>
                </main>

                <footer className="admin-footer">
                    <p>Sistema De atendimento Alpha Hospitalar unidade Guido Guida Poa São Paulo © 2026</p>
                </footer>
            </section>
        </div>
    );
}
