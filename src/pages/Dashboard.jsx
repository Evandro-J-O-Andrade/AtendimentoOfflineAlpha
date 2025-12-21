import React from "react";
import Sidebar from "../pages/Sidebar";

export default function Dashboard() {
  return (
    <div style={{ display: "flex", height: "100vh" }}>
      {/* Sidebar fixa */}
      <Sidebar />

      {/* Conteúdo principal */}
      <main style={{ flex: 1, padding: "20px" }}>
        <h1>Bem-vindo, Administrador!</h1>
        <p>Aqui você pode gerenciar atendimentos, usuários e relatórios.</p>

        {/* Exemplo de cards */}
        <div style={{ display: "flex", gap: "20px", marginTop: "20px" }}>
          <div style={cardStyle}>
            <h3>Total de Atendimentos</h3>
            <p>120</p>
          </div>
          <div style={cardStyle}>
            <h3>Atendimentos Pendentes</h3>
            <p>35</p>
          </div>
          <div style={cardStyle}>
            <h3>Usuários Cadastrados</h3>
            <p>50</p>
          </div>
        </div>
      </main>
    </div>
  );
}

// Estilo simples para os cards
const cardStyle = {
  background: "#f5f5f5",
  padding: "20px",
  borderRadius: "8px",
  boxShadow: "0 2px 5px rgba(0,0,0,0.1)",
  flex: 1,
  textAlign: "center",
};
