/**
 * Dashboard Principal - Área de trabalho do sistema
 * HIS/PA - Sistema de Prontuário Ambulatorial
 * 
 * Usa menu dinâmico baseado em permissões do banco
 */

import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../apps/operacional/auth/AuthProvider";
import { useMenu } from "../hooks/useMenu";
import "./Dashboard.css";

export default function Dashboard() {
  const navigate = useNavigate();
  const { session, logout } = useAuth();
  const { menu, loading } = useMenu();
  const [itemAtivo, setItemAtivo] = useState(null);

  // Se não tem sessão, redireciona para login
  useEffect(() => {
    if (!session && !loading) {
      navigate("/login");
    }
  }, [session, navigate, loading]);

  // Se não tem contexto definido, redireciona para seleção
  useEffect(() => {
    if (session && !session.contexto_definido) {
      navigate("/contexto");
    }
  }, [session, navigate]);

  // Logout
  const handleLogout = async () => {
    await logout();
    navigate("/login");
  };

  // Clique em item do menu
  const handleItemClick = (acao) => {
    setItemAtivo(acao.codigo);
    
    // Se tem ação frontend, navega
    if (acao.acao_frontend) {
      navigate("/" + acao.acao_frontend);
    }
  };

  // Se está carregando, mostra tela de loading
  if (loading) {
    return (
      <div className="dashboard-loading">
        <div className="loading-spinner">⏳</div>
        <p>Carregando permissões...</p>
      </div>
    );
  }

  return (
    <div className="dashboard-container">
      {/* Header */}
      <header className="dashboard-header">
        <div className="header-left">
          <h1>🏥 HIS/PA - Prontuário Ambulatorial</h1>
        </div>
        <div className="header-right">
          <div className="user-info">
            <span className="user-name">{session?.usuario?.login || "Usuário"}</span>
            <span className="user-context">
              {session?.id_perfil ? `Perfil: ${session.id_perfil}` : "Sem perfil"}
              {session?.id_unidade ? ` - Unidade: ${session.id_unidade}` : ""}
            </span>
          </div>
          <button className="btn-logout" onClick={handleLogout}>
            🚪 Sair
          </button>
        </div>
      </header>

      <div className="dashboard-body">
        {/* Sidebar com Menu Dinâmico */}
        <aside className="dashboard-sidebar">
          <div className="menu-list">
            {menu.map((mod) => (
              <div key={mod.modulo} className="menu-modulo">
                <h3 className="menu-titulo">{mod.nome || mod.modulo}</h3>
                <div className="menu-acoes">
                  {mod.acoes?.map((acao) => (
                    <button 
                      key={acao.codigo} 
                      className={`menu-item ${itemAtivo === acao.codigo ? 'active' : ''}`}
                      onClick={() => handleItemClick(acao)}
                    >
                      {acao.nome}
                    </button>
                  ))}
                </div>
              </div>
            ))}
            {!menu.length && <p className="menu-vazio">Nenhuma permissão encontrada</p>}
          </div>
        </aside>

        {/* Área de Trabalho */}
        <main className="dashboard-main">
          <div className="workarea-header">
            <h2>{itemAtivo ? "Área de Trabalho" : "Bem-vindo ao HIS/PA"}</h2>
          </div>
          
          <div className="workarea-content">
            {itemAtivo ? (
              <div className="workarea-module">
                <p>Módulo: {itemAtivo}</p>
              </div>
            ) : (
              <div className="workarea-welcome">
                <h3>📋 Dashboard</h3>
                <p>Selecione uma opção no menu para começar.</p>
                
                {/* Stats rápidas */}
                <div className="quick-stats">
                  <div className="stat">
                    <span className="stat-label">Módulos</span>
                    <span className="stat-value">{menu.length}</span>
                  </div>
                  <div className="stat">
                    <span className="stat-label">Perfil</span>
                    <span className="stat-value">{session?.id_perfil || "-"}</span>
                  </div>
                  <div className="stat">
                    <span className="stat-label">Unidade</span>
                    <span className="stat-value">{session?.id_unidade || "-"}</span>
                  </div>
                </div>
              </div>
            )}
          </div>
        </main>
      </div>
    </div>
  );
}
