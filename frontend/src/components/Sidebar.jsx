import { useState } from "react";
import { Link } from "react-router-dom";
import "../apps/operacional/layout/sidebar.css";

export default function Sidebar() {
    const [collapsed, setCollapsed] = useState(false);

    return (
        <aside className={"ao-sidebar " + (collapsed ? "collapsed" : "") }>
            <div className="sidebar-top">
                <div className="brand">
                    <div className="logo">AO</div>
                    <div className="title">AtendimentoOffline</div>
                </div>
                <button className="toggle" onClick={() => setCollapsed(!collapsed)}>
                    ☰
                </button>
            </div>

            <nav className="nav">
                <Link to="/operacional" className="nav-item">Painel</Link>
                <Link to="#" className="nav-item">Pacientes</Link>
                <Link to="#" className="nav-item">Agendamentos</Link>
                <Link to="#" className="nav-item">Caixa</Link>
                <Link to="#" className="nav-item">Relatórios</Link>
            </nav>

            <div className="sidebar-bottom">
                <div className="user">Usuário: <strong>teste.runtime</strong></div>
            </div>
        </aside>
    );
}
