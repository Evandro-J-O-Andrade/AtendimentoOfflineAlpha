import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import api from "../../../api/api";
import { useApp } from "../../../context/AppContext";
import "./Admin.css";

export default function Admin() {
    const navigate = useNavigate();
    const { contexto, usuario, getToken, logout } = useApp();
    const [adminData, setAdminData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [activeSection, setActiveSection] = useState("dashboard");

    useEffect(() => {
        async function fetchAdminData() {
            try {
                const res = await api.get("/painel/admin");
                setAdminData(res.data);
            } catch (err) {
                const apiErr = err?.response?.data?.error || err?.response?.data?.erro;
                if (apiErr === "TOKEN_EXPIRADO") {
                    logout();
                    navigate("/login", { replace: true });
                    return;
                }
                setError(err.message);
            } finally {
                setLoading(false);
            }
        }

        fetchAdminData();
    }, [usuario, getToken]);

    if (loading) {
        return <div className="admin-loading">Carregando painel administrativo...</div>;
    }

    function goTo(path) {
        navigate(path);
    }

    function handleLogout() {
        logout();
        navigate("/login");
    }

    const menuItems = [
        { id: "dashboard", label: "Dashboard", icon: "📊" },
        { id: "acesso", label: "Acesso ao Sistema", icon: "🔐" },
        { id: "operacao", label: "Fluxo Operacional", icon: "⚙️" },
        { id: "cadastros", label: "Cadastros", icon: "📁" }
    ];

    const getInitials = (name) => {
        if (!name) return "A";
        return name.split(" ").map(n => n[0]).join("").substring(0, 2).toUpperCase();
    };

    return (
        <div className="admin-container">
            <aside className="admin-sidebar">
                <div className="admin-brand">
                    <span className="logo-icon">🏥</span>
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
                            <span>{item.icon}</span>
                            {item.label}
                        </button>
                    ))}
                </nav>

                <button type="button" className="admin-logout" onClick={handleLogout}>
                    🚪 Sair
                </button>
            </aside>

            <section className="admin-content">
                <header className="admin-header">
                    <h1>Sistema de Atendimento Alpha Hospitalar - Unidade Guido Guida</h1>
                    <div className="admin-user">
                        <span>Perfil: <strong>{adminData?.usuario?.perfil || contexto?.id_perfil}</strong></span>
                        <div className="user-avatar">
                            {getInitials(adminData?.usuario?.nome || usuario?.login)}
                        </div>
                    </div>
                </header>

                <main className="admin-main">
                    <div className="admin-cards">
                        {activeSection === "dashboard" && (
                            <>
                                <div className="admin-card">
                                    <div className="card-icon">📊</div>
                                    <h3>Painel Administrativo</h3>
                                    <p>Visão geral de acesso, módulos e monitoramento do sistema.</p>
                                    <button className="card-button" onClick={() => goTo("/admin")}>Atualizar</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">📺</div>
                                    <h3>Painel de Chamadas</h3>
                                    <p>Exibição de senhas e fluxo de atendimento em tempo real.</p>
                                    <button className="card-button" onClick={() => goTo("/painel-chamadas")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">👥</div>
                                    <h3>Usuários Ativos</h3>
                                    <p>Gerencie usuários e permissões de acesso ao sistema.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/usuarios")}>Gerenciar</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">📈</div>
                                    <h3>Relatórios</h3>
                                    <p>Acompanhe métricas e relatórios do sistema.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/relatorios")}>Ver</button>
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
                                    <p>Usuário escolhe local de atendimento antes de operar.</p>
                                    <button className="card-button" onClick={() => goTo("/contexto")}>Selecionar</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">🔑</div>
                                    <h3>Permissões</h3>
                                    <p>Configure perfis e permissões de acesso.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/perfil")}>Configurar</button>
                                </div>
                            </>
                        )}

                        {activeSection === "operacao" && (
                            <>
                                <div className="admin-card">
                                    <div className="card-icon">🎟️</div>
                                    <h3>Totem / Senha</h3>
                                    <p>Geração de senha e início do fluxo do paciente.</p>
                                    <button className="card-button" onClick={() => goTo("/totem")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">📋</div>
                                    <h3>Recepção</h3>
                                    <p>Registro inicial e encaminhamento no atendimento.</p>
                                    <button className="card-button" onClick={() => goTo("/recepcao")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">🩺</div>
                                    <h3>Triagem</h3>
                                    <p>Classificação de risco e preparo para consulta.</p>
                                    <button className="card-button" onClick={() => goTo("/triagem")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">⚕️</div>
                                    <h3>Atendimento Médico</h3>
                                    <p>Consulta médica e prescrições.</p>
                                    <button className="card-button" onClick={() => goTo("/medico")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">💊</div>
                                    <h3>Farmácia</h3>
                                    <p>Dispensação de medicamentos.</p>
                                    <button className="card-button" onClick={() => goTo("/farmacia")}>Abrir</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">🏥</div>
                                    <h3>Enfermagem</h3>
                                    <p>Procedimentos de enfermagem.</p>
                                    <button className="card-button" onClick={() => goTo("/enfermagem")}>Abrir</button>
                                </div>
                            </>
                        )}

                        {activeSection === "cadastros" && (
                            <>
                                <div className="admin-card">
                                    <div className="card-icon">👤</div>
                                    <h3>Pacientes</h3>
                                    <p>Cadastro e gestão de pacientes.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/pacientes")}>Gerenciar</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">🧑‍⚕️</div>
                                    <h3>Profissionais</h3>
                                    <p>Cadastro de médicos e enfermeiros.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/profissionais")}>Gerenciar</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">🏢</div>
                                    <h3>Unidades</h3>
                                    <p>Gestão de unidades e locais operacionais.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/unidades")}>Gerenciar</button>
                                </div>
                                <div className="admin-card">
                                    <div className="card-icon">💊</div>
                                    <h3>Medicamentos</h3>
                                    <p>Catálogo de medicamentos e estoque.</p>
                                    <button className="card-button" onClick={() => goTo("/admin/medicamentos")}>Gerenciar</button>
                                </div>
                            </>
                        )}
                    </div>
                </main>
            </section>
        </div>
    );
}
