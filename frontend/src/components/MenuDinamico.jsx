import React from "react";
import { Link, useNavigate } from "react-router-dom";
import { executarAcao } from "../services/runtimeService";

/**
 * Menu Dinâmico - Renderiza o menu baseado nas permissões do banco
 * @param {Object} props
 * @param {Object} props.menu - Menu estruturado por grupo
 * @param {Function} props.onAction - Callback quando uma ação é clicada
 * @param {string} props.ativo - Item atualmente ativo
 */
export default function MenuDinamico({ menu, onAction, ativo }) {
  const navigate = useNavigate();

  if (!menu || Object.keys(menu).length === 0) {
    return (
      <div className="menu-vazio">
        <p>Nenhuma permissão encontrada</p>
      </div>
    );
  }

  const handleClick = async (item) => {
    // Se tem ação definida, executa via dispatcher
    if (item.acao) {
      try {
        const resultado = await executarAcao(item.acao, {});
        if (resultado.sucesso && onAction) {
          onAction(item.acao, resultado);
        }
      } catch (err) {
        console.error("Erro ao executar ação:", err);
      }
    }
    
    // Se tem URL, navega
    if (item.url) {
      navigate(item.url);
    }
  };

  // Ícones disponíveis (pode ser expandido)
  const icones = {
    home: "🏠",
    usuario: "👤",
    senha: "🎫",
    triagem: "⚕️",
    atendimento: "🩺",
    farmacia: "💊",
    enfermagem: "🏥",
    medico: "👨‍⚕️",
    painel: "📊",
    totem: "🖥️",
    admin: "⚙️",
    relatorio: "📋",
    config: "🔧"
  };

  const getIcone = (iconeNome) => {
    return icones[iconeNome] || "•";
  };

  return (
    <nav className="menu-dinamico">
      {Object.entries(menu).map(([grupo, itens]) => (
        <div key={grupo} className="menu-grupo">
          <h3 className="menu-titulo-grupo">{grupo}</h3>
          <ul className="menu-lista">
            {itens.map((item) => (
              <li key={item.codigo} className="menu-item">
                <button
                  className={`menu-botao ${ativo === item.codigo ? "ativo" : ""}`}
                  onClick={() => handleClick(item)}
                  title={item.nome}
                >
                  <span className="menu-icone">
                    {getIcone(item.icone)}
                  </span>
                  <span className="menu-label">{item.nome}</span>
                </button>
              </li>
            ))}
          </ul>
        </div>
      ))}
    </nav>
  );
}

// ============================================
// Componente de Menu Lateral (Sidebar)
// ============================================
export function MenuLateral({ menu, ativo, onToggle }) {
  return (
    <aside className="menu-lateral">
      <div className="menu-lateral-header">
        <button className="menu-toggle" onClick={onToggle}>
          ☰
        </button>
      </div>
      <MenuDinamico menu={menu} ativo={ativo} />
    </aside>
  );
}

// ============================================
// Componente de Menu Superior (Topbar)
// ============================================
export function MenuSuperior({ menu, ativo, onAction }) {
  // Pega apenas os primeiros itens de cada grupo para o menu horizontal
  const itensFlatuados = Object.values(menu).flat().slice(0, 6);

  return (
    <nav className="menu-superior">
      {itensFlatuados.map((item) => (
        <button
          key={item.codigo}
          className={`menu-superior-item ${ativo === item.codigo ? "ativo" : ""}`}
          onClick={() => {
            if (item.url) {
              window.location.href = item.url;
            } else if (item.acao && onAction) {
              onAction(item.acao);
            }
          }}
        >
          {item.nome}
        </button>
      ))}
    </nav>
  );
}
