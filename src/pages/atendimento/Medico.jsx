import React, { useEffect, useState } from "react";
import Header from "@/components/Header";
import Sidebar from "@/pages/Sidebar";
import api from "@/services/api";
import { useAuth } from "@/context/AuthContext";

export default function Medico() {
  const { user } = useAuth();
  const [fila, setFila] = useState([]);

  useEffect(() => {
    api.get("/atendimento_medico.php")
      .then(res => setFila(Array.isArray(res.data) ? res.data : []))
      .catch(err => console.error(err));
  }, []);

  return (
    <div className="medico-page">
      <Header />
      <div className="content-wrapper">
        <Sidebar />
        <main className="main-content">
          <h2>Médico - Fila de Atendimentos</h2>

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
        </main>
      </div>

    </div>
  );
}
