import React, { useEffect, useState } from "react";
import Header from "../../components/Header";
import Sidebar from "../Sidebar";
import Card from "../../components/Card";
import api from "../../services/api";
import { useAuth } from "../../context/AuthContext";
import "./Dashboard.css";

export default function Dashboard() {
  const { user } = useAuth();

  const [stats, setStats] = useState({
    total: 0,
    pendentes: 0,
    usuarios: 0
  });
  const [fila, setFila] = useState([]);

  // Função para carregar dados da fila e stats
  const carregarFila = async () => {
    try {
      const res = await api.get("/atendimento.php");
      const data = Array.isArray(res.data) ? res.data : [];

      // Padroniza nomes dos campos
      const filaPadronizada = data.map(p => ({
        id: p.id || p.id_ffa,
        senha: p.gpat || p.senha,
        nome: p.nome_completo || p.nome,
        prioridade: p.score_prioridade || p.prioridade || "-",
        status_atendimento: p.status || p.status_atendimento || "-",
        hora_chegada: p.criado_em || p.hora_chegada || "-"
      }));

      setFila(filaPadronizada);

      // Atualiza stats
      setStats({
        total: filaPadronizada.length,
        pendentes: filaPadronizada.filter(p => p.status_atendimento === "AGUARDANDO_MEDICO" || p.status_atendimento === "PENDENTE").length,
        usuarios: 50 // futuramente buscar do backend /usuarios/count
      });

    } catch (err) {
      console.error("Erro ao carregar fila:", err);
    }
  };

  useEffect(() => {
    carregarFila(); // primeiro carregamento
    const intervalo = setInterval(carregarFila, 5000); // atualiza a cada 5s
    return () => clearInterval(intervalo);
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
                {fila.length > 0 ? (
                  fila.map(p => (
                    <tr key={p.id}>
                      <td>{p.senha}</td>
                      <td>{p.nome}</td>
                      <td>{p.prioridade}</td>
                      <td>{p.status_atendimento}</td>
                      <td>{p.hora_chegada}</td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="5">Nenhum paciente na fila</td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </main>
      </div>
    </div>
  );
}
