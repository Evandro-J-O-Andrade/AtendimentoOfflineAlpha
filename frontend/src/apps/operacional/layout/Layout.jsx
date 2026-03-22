import { useState, useEffect } from "react";
import { Link, useLocation } from "react-router-dom";
import { useAuth } from "../../../context/AuthProvider";
import spApi from "../../../api/spApi";
import "./Layout.css";

export default function Layout({ children }) {
    const { session, logout } = useAuth();
    const location = useLocation();
    const [perfilNome, setPerfilNome] = useState("");
    const [unidadeNome, setUnidadeNome] = useState("");
    const [currentTime, setCurrentTime] = useState(new Date());

    // Atualiza o relógio a cada segundo
    useEffect(() => {
        const timer = setInterval(() => setCurrentTime(new Date()), 1000);
        return () => clearInterval(timer);
    }, []);

    // Busca nomes do contexto
    useEffect(() => {
        async function fetchContextNames() {
            if (!session?.id_sessao) return;
            try {
                const data = await spApi.call('sp_auth_listar_contextos', {
                    p_id_sessao: session.id_sessao
                });
                if (data && data.resultado) {
                    const perfis = data.resultado.perfis || {};
                    const unidades = data.resultado.unidades || {};
                    
                    if (session.id_perfil) {
                        setPerfilNome(perfis[session.id_perfil] || `Perfil ${session.id_perfil}`);
                    }
                    if (session.id_unidade) {
                        setUnidadeNome(unidades[session.id_unidade] || `Unidade ${session.id_unidade}`);
                    }
                }
            } catch (e) {
                console.log("Erro ao buscar nomes:", e);
                setPerfilNome(`Perfil ${session?.id_perfil || "-"}`);
                setUnidadeNome(`Unidade ${session?.id_unidade || "-"}`);
            }
        }
        fetchContextNames();
    }, [session]);

    const localNome = session?.id_local 
        ? `Local ${session.id_local}`
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
        !item.perfis || item.perfis.includes(Number(session?.id_perfil))
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
                        <span className="user-id">Usuário: {session?.id_sessao || "-"}</span>
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
