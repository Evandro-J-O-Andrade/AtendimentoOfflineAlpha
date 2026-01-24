import React from "react";
import { NavLink, useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import { useContextoAtendimento } from "@/context/ContextoAtendimento";
import "./Sidebar.css";

function perfisUpper(perfis) {
  if (!Array.isArray(perfis)) return [];
  return perfis.map((p) => String(p || "").toUpperCase());
}

export default function Sidebar() {
  const { user, signOut } = useAuth();
  const { contexto, limparContexto } = useContextoAtendimento();
  const navigate = useNavigate();

  const perfis = perfisUpper(user?.perfis);
  const isRecepcao = perfis.includes("RECEPCAO") || perfis.includes("ADM_RECEPCAO");
  const isMedico = perfis.some((p) => p.includes("MEDICO"));
  const isEnfermagem = perfis.includes("ENFERMAGEM") || perfis.includes("TECNICO_ENFERMAGEM") || perfis.includes("TRIAGEM");
  const isAdmin = perfis.includes("ADMIN_MASTER") || perfis.includes("MASTER") || perfis.includes("SUPORTE") || perfis.includes("SUPORTE_MASTER");

  const localLabel = (() => {
    const l = contexto?.local;
    if (!l) return "(sem local)";
    if (typeof l === "string") return l;
    const nome = l.nome || l.name || "";
    const tipo = l.tipo ? ` (${l.tipo})` : "";
    return `${nome}${tipo}`.trim() || "(sem local)";
  })();

  const handleTrocarContexto = () => {
    limparContexto();
    navigate("/contexto");
  };

  const handleSair = () => {
    limparContexto();
    signOut();
    navigate("/login");
  };

  return (
    <aside className="sidebar">
      <div className="sidebar-header">
        <h2>Pronto Atendimento</h2>
        <div className="sidebar-sub">
          <div className="sidebar-user">{user?.nome ?? user?.login}</div>
          <div className="sidebar-local">{localLabel}</div>
        </div>
      </div>

      <nav className="sidebar-menu">
        {isRecepcao && <NavLink to="/recepcao">Recepção</NavLink>}
        {isMedico && <NavLink to="/medico/fila">Fila Médico</NavLink>}
        {isEnfermagem && <NavLink to="/triagem">Triagem</NavLink>}
        {isAdmin && <NavLink to="/dashboard">Dashboard</NavLink>}
        {isAdmin && <NavLink to="/admin/usuarios">Gestão de Usuários</NavLink>}
      </nav>

      <div className="sidebar-footer">
        <button onClick={handleTrocarContexto}>Trocar Contexto</button>
        <button onClick={handleSair}>Sair</button>
      </div>
    </aside>
  );
}
