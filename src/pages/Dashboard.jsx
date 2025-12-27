import React, { useEffect, useState } from "react";
import Header from "../components/Header";
import Sidebar from "../pages/Sidebar";
import Card from "../components/Card";
import api from "../api/api";
import { useAuth } from "../auth/AuthContext";
import "./Dashboard.css";

export default function Dashboard() {
  const { user } = useAuth();

  const [stats, setStats] = useState({
    total: 0,
    pendentes: 0,
    usuarios: 0
  });
  const [fila, setFila] = useState([]);

  useEffect(() => {
    // Buscar estatísticas gerais
    api.get("/atendimento.php")
      .then(res => {
        const data = Array.isArray(res.data) ? res.data : [];
        setFila(data);
        setStats({
          total: data.length,
          pendentes: data.filter(p => p.status_atendimento === "PENDENTE").length,
          usuarios: 50 // ou buscar do banco de usuários
        });
      })
      .catch(err => console.error(err));
  }, []);

  return (
    <div className="dashboard-page">
      <Header />

      <div className="dashboard-content">
        {/* Sidebar lateral */}
        <Sidebar usuario={user} />

        {/* Área principal */}
        <main className="main-content">
          <h2>Dashboard - Indicadores Gerais</h2>

          {/* Cards de estatísticas */}
          <div className="cards-container">
            <Card title="Total de Atendimentos" value={stats.total} />
            <Card title="Atendimentos Pendentes" value={stats.pendentes} />
            <Card title="Usuários Cadastrados" value={stats.usuarios} />
          </div>

          {/* Lista detalhada da fila */}
          <div className="fila-detalhada">
            <h3>Lista Detalhada de Pacientes</h3>
            <table>
              <thead>
                <tr>
                  <th>Senha</th>
                  <th>Paciente</th>
                  <th>Prioridade</th>
                  <th>Status</th>
                  <th>Chegada</th>
                </tr>
              </thead>
              <tbody>
                {fila.map(p => (
                  <tr key={p.id}>
                    <td>{p.senha}</td>
                    <td>{p.nome}</td>
                    <td>{p.prioridade}</td>
                    <td>{p.status_atendimento}</td>
                    <td>{p.hora_chegada}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </main>
      </div>
    </div>
  );
}
