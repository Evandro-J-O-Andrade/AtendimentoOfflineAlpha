import { useState, useEffect } from "react";
import { Link, useLocation } from "react-router-dom";
import { useAuth } from "../../../context/AuthProvider";
import spApi from "../../../api/spApi";
import "./Layout.css";

interface MenuItem {
    path: string;
    label: string;
    icon: string;
    modulo: string;
    perfis?: number[];
}

interface Session {
    id_sessao?: number;
    id_perfil?: number;
    id_unidade?: number;
    id_local?: number;
    [key: string]: unknown;
}

export default function Layout({ children }: { children: React.ReactNode }) {
    const { session, logout } = useAuth();
    const location = useLocation();
    const [perfilNome, setPerfilNome] = useState("");
    const [unidadeNome, setUnidadeNome] = useState("");
    const [currentTime, setCurrentTime] = useState(new Date());

    useEffect(() => {
        const timer = setInterval(() => setCurrentTime(new Date()), 1000);
        return () => clearInterval(timer);
    }, []);

    useEffect(() => {
        async function fetchContextNames() {
            if (!(session as Session)?.id_sessao) return;
            try {
                const data = await spApi.call('sp_auth_listar_contextos', {
                    p_id_sessao: (session as Session).id_sessao
                });
                if (data && data.resultado) {
                    const perfis = data.resultado.perfis || {};
                    const unidades = data.resultado.unidades || {};
                    
                    if ((session as Session).id_perfil) {
                        setPerfilNome(perfis[(session as Session).id_perfil] || `Perfil ${(session as Session).id_perfil}`);
                    }
                    if ((session as Session).id_unidade) {
                        setUnidadeNome(unidades[(session as Session).id_unidade] || `Unidade ${(session as Session).id_unidade}`);
                    }
                }
            } catch (e) {
                console.log("Erro ao buscar nomes:", e);
                setPerfilNome(`Perfil ${(session as Session)?.id_perfil || "-"}`);
                setUnidadeNome(`Unidade ${(session as Session)?.id_unidade || "-"}`);
            }
        }
        fetchContextNames();
    }, [session]);

    const localNome = (session as Session)?.id_local 
        ? `Local ${(session as Session).id_local}`
        : null;

    const menuItems: MenuItem[] = [
        { path: "/operacional", label: "Início", icon: "🏠", modulo: "Sistema" },
        { path: "/operacional/recepcao", label: "Recepção", icon: "📋", modulo: "Assistencial", perfis: [1, 2] },
        { path: "/operacional/triagem", label: "Triagem", icon: "🩺", modulo: "Assistencial", perfis: [2, 3] },
        { path: "/operacional/enfermagem", label: "Enfermagem", icon: "🏥", modulo: "Assistencial", perfis: [2, 5] },
        { path: "/operacional/medico", label: "Médico", icon: "⚕️", modulo: "Assistencial", perfis: [3] },
        { path: "/operacional/internacao", label: "Internação", icon: "🛏️", modulo: "Assistencial", perfis: [1, 3, 5] },
        { path: "/operacional/ambulancia", label: "Ambulância", icon: "🚑", modulo: "Assistencial", perfis: [1, 2] },
        { path: "/operacional/remocao", label: "Remoção", icon: "🚒", modulo: "Assistencial", perfis: [1, 2] },
        { path: "/operacional/farmacia", label: "Farmácia", icon: "💊", modulo: "Serviços", perfis: [4] },
        { path: "/operacional/laboratorio", label: "Laboratório", icon: "🧪", modulo: "Serviços", perfis: [1, 3, 4] },
        { path: "/operacional/manutencao", label: "Manutenção", icon: "🔧", modulo: "Serviços", perfis: [1] },
        { path: "/operacional/gasoterapia", label: "Gasoterapia", icon: "💨", modulo: "Especialidades", perfis: [1, 3, 5] },
        { path: "/operacional/nutricao", label: "Nutrição", icon: "🥗", modulo: "Especialidades", perfis: [1, 3, 5] },
        { path: "/operacional/assistencia-social", label: "Assist. Social", icon: "🤝", modulo: "Especialidades", perfis: [1, 5] },
        { path: "/operacional/interconsulta", label: "Interconsulta", icon: "📞", modulo: "Especialidades", perfis: [1, 3] },
        { path: "/operacional/faturamento", label: "Faturamento", icon: "💰", modulo: "Administrativo", perfis: [1, 42] },
        { path: "/operacional/estoque", label: "Estoque", icon: "📦", modulo: "Administrativo", perfis: [1, 4] },
        { path: "/operacional/pdv", label: "PDV", icon: "🛒", modulo: "Administrativo", perfis: [1] },
        { path: "/operacional/cat", label: "CAT", icon: "📋", modulo: "Administrativo", perfis: [1, 5] },
        { path: "/operacional/obito", label: "Óbito", icon: "⚰️", modulo: "Administrativo", perfis: [1, 5] },
        { path: "/operacional/atendimento", label: "Atendimento", icon: "🎯", modulo: "Sistema", perfis: [1, 3] },
        { path: "/operacional/executor/evolucao", label: "Evolução", icon: "📝", modulo: "Sistema", perfis: [1, 3, 5] },
        { path: "/operacional/executor/estoque", label: "Exec. Estoque", icon: "🔄", modulo: "Sistema", perfis: [1, 4] },
        { path: "/operacional/executor/faturamento", label: "Exec. Faturamento", icon: "📊", modulo: "Sistema", perfis: [1, 42] },
        { path: "/operacional/fluxo/estoque", label: "Fluxo Estoque", icon: "↔️", modulo: "Sistema", perfis: [1, 4] },
        { path: "/operacional/coordenador/global", label: "Coordenação", icon: "🎮", modulo: "Sistema", perfis: [1, 42] },
        { path: "/operacional/admin", label: "Administração", icon: "⚙️", modulo: "Admin", perfis: [1, 42] },
    ];

    const filteredMenu = menuItems.filter(item => 
        !item.perfis || item.perfis.includes(Number((session as Session)?.id_perfil))
    );

    const modulos = ['Sistema', 'Assistencial', 'Serviços', 'Especialidades', 'Administrativo', 'Admin'];
    const menuAgrupado = modulos.map(modulo => ({
        nome: modulo,
        items: filteredMenu.filter(item => item.modulo === modulo)
    })).filter(modulo => modulo.items.length > 0);

    function handleLogout() {
        logout();
        window.location.href = "/login";
    }

    return (
        <div className="layout-container">
            <aside className="sidebar">
                <div className="sidebar-header">
                    <img src="/assets/img/logosenfundo.png" alt="Logo" className="sidebar-logo" />
                    <span className="sidebar-title">Alpha PA</span>
                </div>

                <nav className="sidebar-nav">
                    {menuAgrupado.map(modulo => (
                        <div key={modulo.nome} className="menu-grupo">
                            <div className="menu-grupo-titulo">{modulo.nome}</div>
                            {modulo.items.map(item => (
                                <Link 
                                    key={item.path}
                                    to={item.path}
                                    className={`nav-item ${location.pathname === item.path ? "active" : ""}`}
                                >
                                    <span className="nav-icon">{item.icon}</span>
                                    <span className="nav-label">{item.label}</span>
                                </Link>
                            ))}
                        </div>
                    ))}
                </nav>

                <div className="sidebar-footer">
                    <button onClick={handleLogout} className="btn-logout">
                        🚪 Sair
                    </button>
                </div>
            </aside>

            <div className="main-wrapper">
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
                        <span className="user-id">Usuário: {(session as Session)?.id_sessao || "-"}</span>
                    </div>
                </header>

                <main className="page-content">
                    {children}
                </main>
            </div>
        </div>
    );
}