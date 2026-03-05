import { useState, useEffect } from "react";
import { Link, useLocation } from "react-router-dom";
import { useRuntimeAuth } from "../auth/RuntimeAuthContext";
import "./Layout.css";

export default function Layout({ children }) {
    const { session, logout, authFetch } = useRuntimeAuth();
    const location = useLocation();
    const [contextNames, setContextNames] = useState({});
    const [currentTime, setCurrentTime] = useState(new Date());

    // Atualiza o relógio a cada segundo
    useEffect(() => {
        const timer = setInterval(() => setCurrentTime(new Date()), 1000);
        return () => clearInterval(timer);
    }, []);

    // Busca nomes do contexto
    useEffect(() => {
        async function fetchContextNames() {
            try {
                const res = await authFetch("/api/auth/contextos");
                if (res.ok) {
                    const data = await res.json();
                    setContextNames(data);
                }
            } catch (e) {
                console.log("Erro ao buscar nomes:", e);
            }
        }
        fetchContextNames();
    }, [authFetch]);

    const user = session?.user || {};
    const perfilNome = contextNames.perfis?.[user.id_perfil] || `Perfil ${user.id_perfil || "-"}`;
    const unidadeNome = contextNames.unidades?.[user.id_unidade] || `Unidade ${user.id_unidade || "-"}`;
    const localNome = user.id_local_operacional 
        ? (contextNames.locais?.[user.id_local_operacional] || `Local ${user.id_local_operacional}`)
        : null;

    // Itens de menu baseados no perfil
    const menuItems = [
        { path: "/operacional", label: "Início", icon: "🏠" },
        { path: "/operacional/recepcao", label: "Recepção", icon: "📋", perfis: [1, 2] },
        { path: "/operacional/triagem", label: "Triagem", icon: "🩺", perfis: [2, 3] },
        { path: "/operacional/medico", label: "Médico", icon: "⚕️", perfis: [3] },
        { path: "/operacional/farmacia", label: "Farmácia", icon: "💊", perfis: [4] },
        { path: "/operacional/enfermagem", label: "Enfermagem", icon: "🏥", perfis: [2, 5] },
    ];

    // Filtra itens por perfil
    const filteredMenu = menuItems.filter(item => 
        !item.perfis || item.perfis.includes(Number(user.id_perfil))
    );

    function handleLogout() {
        logout();
        window.location.href = "/login";
    }

    return (
        <div className="layout-container">
            {/* Sidebar */}
            <aside className="sidebar">
                <div className="sidebar-header">
                    <img src="/assets/img/logosenfundo.png" alt="Logo" className="sidebar-logo" />
                    <span className="sidebar-title">Alpha PA</span>
                </div>

                <nav className="sidebar-nav">
                    {filteredMenu.map(item => (
                        <Link 
                            key={item.path}
                            to={item.path}
                            className={`nav-item ${location.pathname === item.path ? "active" : ""}`}
                        >
                            <span className="nav-icon">{item.icon}</span>
                            <span className="nav-label">{item.label}</span>
                        </Link>
                    ))}
                </nav>

                <div className="sidebar-footer">
                    <button onClick={handleLogout} className="btn-logout">
                        🚪 Sair
                    </button>
                </div>
            </aside>

            {/* Main Content */}
            <div className="main-wrapper">
                {/* Header */}
                <header className="header">
                    <div className="header-context">
                        <div className="context-info">
                            <span className="context-perfil">{perfilNome}</span>
                            <span className="context-divider">|</span>
                            <span className="context-unidade">{unidadeNome}</span>
                            {localNome && (
                                <>
                                    <span className="context-divider">|</span>
                                    <span className="context-local">{localNome}</span>
                                </>
                            )}
                        </div>
                        <div className="header-time">
                            <span className="time-date">{currentTime.toLocaleDateString("pt-BR")}</span>
                            <span className="time-hour">{currentTime.toLocaleTimeString("pt-BR")}</span>
                        </div>
                    </div>
                    <div className="header-user">
                        <span className="user-id">Usuário: {user.id_usuario}</span>
                    </div>
                </header>

                {/* Page Content */}
                <main className="page-content">
                    {children}
                </main>
            </div>
        </div>
    );
}
