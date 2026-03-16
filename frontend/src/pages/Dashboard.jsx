/**
 * Dashboard Principal - Área de trabalho do sistema
 * HIS/PA - Sistema de Prontuário Ambulatorial
 * 
 * Usa menu dinâmico baseado em permissões do banco
 */

import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useApp } from "../context/AppContext";
import { useMenu } from "../hooks/useMenu";
import MenuDinamico from "../components/MenuDinamico";
import "./Dashboard.css";

export default function Dashboard() {
  const navigate = useNavigate();
  const { usuario, contexto, sessao, permissoes, logout, hasPermission } = useApp();
  const [itemAtivo, setItemAtivo] = useState(null);
  const [dadosDashboard, setDadosDashboard] = useState(null);
  const [loading, setLoading] = useState(false);

  // Carrega menu baseado no perfil do contexto
  const { menu, carregando, erro, temPermissao } = useMenu(contexto?.id_perfil);

  // Se não tem contexto, redireciona para seleção
  useEffect(() => {
    if (!contexto && !loading) {
      navigate("/contexto");
    }
  }, [contexto, navigate, loading]);

  // Função executada quando clica em um item do menu
  const handleAction = async (acao, resultado) => {
    console.log("Ação executada:", acao, resultado);
    
    // Atualiza dados do dashboard se necessário
    if (resultado?.dados) {
      setDadosDashboard(resultado.dados);
    }
  };

  // Clique em item do menu
  const handleItemClick = (item) => {
    setItemAtivo(item.codigo);
    
    // Se tem URL definida, navega
    if (item.url) {
      navigate(item.url);
    }
  };

  // Logout
  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  // Se está carregando, mostra tela de loading
  if (carregando) {
    return (
      <div className="dashboard-loading">
        <div className="loading-spinner">⏳</div>
        <p>Carregando permissões...</p>
      </div>
    );
  }

  // Se tem erro, mostra mensagem
  if (erro) {
    return (
      <div className="dashboard-erro">
        <p>Erro ao carregar menu: {erro}</p>
        <button onClick={() => window.location.reload()}>Recarregar</button>
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
            <span className="user-name">{usuario?.nome || "Usuário"}</span>
            <span className="user-context">
              {contexto?.perfil || "Sem perfil"} - {contexto?.unidade || "Sem unidade"}
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
          <MenuDinamico 
            menu={menu} 
            onAction={handleAction}
            ativo={itemAtivo}
          />
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
                {/* Aqui cada página será renderizada conforme a rota */}
              </div>
            ) : (
              <div className="workarea-welcome">
                <h3>📋 Dashboard</h3>
                <p>Selecione uma opção no menu para começar.</p>
                
                {/* Stats rápidas */}
                <div className="quick-stats">
                  <div className="stat">
                    <span className="stat-label">Permissões</span>
                    <span className="stat-value">{permissoes?.length || 0}</span>
                  </div>
                  <div className="stat">
                    <span className="stat-label">Perfil</span>
                    <span className="stat-value">{contexto?.perfil || "-"}</span>
                  </div>
                  <div className="stat">
                    <span className="stat-label">Unidade</span>
                    <span className="stat-value">{contexto?.unidade || "-"}</span>
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
