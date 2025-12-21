import React, { useEffect, useState } from "react";
import Header from "../components/Header";
import Sidebar from "../pages/Sidebar";
import Card from "../components/Card";
import api from "../api/api";

export default function Dashboard() {
  const [stats, setStats] = useState({
    total: 0,
    pendentes: 0,
    usuarios: 0
  });

  useEffect(() => {
    // Exemplo: buscar estatísticas da API
    api.get("/atendimento.php")
      .then(res => {
        const fila = Array.isArray(res.data) ? res.data : [];
        setStats({
          total: fila.length,
          pendentes: fila.filter(p => p.status_atendimento === "PENDENTE").length,
          usuarios: 50 // se quiser, pode buscar do banco
        });
      })
      .catch(err => console.error(err));
  }, []);

  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100vh" }}>
      {/* Cabeçalho */}
      <Header />

      {/* Conteúdo principal */}
      <div style={{ display: "flex", flex: 1 }}>
        {/* Sidebar */}
        <Sidebar />

        {/* Área principal */}
        <main style={{ flex: 1, padding: "20px", overflowY: "auto" }}>
          <h2>Fila de Atendimentos do Dia</h2>

          {/* Cards de estatísticas */}
          <div style={{ display: "flex", gap: "20px", marginTop: "20px" }}>
            <Card title="Total de Atendimentos" value={stats.total} />
            <Card title="Atendimentos Pendentes" value={stats.pendentes} />
            <Card title="Usuários Cadastrados" value={stats.usuarios} />
          </div>

          {/* Lista detalhada */}
          <div style={{ marginTop: "30px" }}>
            <h3>Lista Detalhada de Pacientes</h3>
            <p>Aqui será implementada a lista detalhada da fila de atendimentos.</p>
          </div>
        </main>
      </div>
    </div>
  );
}
