import React, { useEffect, useState } from "react";
import Header from "../components/Header";
import Sidebar from "../pages/Sidebar";
import api from "../api/api";
import { useAuth } from "../auth/AuthContext";
import SelectLocalModal from "../components/SelectLocalModal";

export default function Medico() {
  const { user } = useAuth();
  const [fila, setFila] = useState([]);
  const [openLocalModal, setOpenLocalModal] = useState(false);

  useEffect(() => {
    api.get("/atendimento_medico.php")
      .then(res => setFila(Array.isArray(res.data) ? res.data : []))
      .catch(err => console.error(err));
  }, []);

  useEffect(() => {
    if (user && user.perfis.includes("MEDICO") && !user.localSelecionado) {
      setOpenLocalModal(true);
    }
  }, [user]);

  return (
    <div className="medico-page">
      <Header />
      <div className="content-wrapper">
        <Sidebar usuario={user} />
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

      {user && openLocalModal && (
        <SelectLocalModal
          open={openLocalModal}
          onClose={() => setOpenLocalModal(false)}
          onSelect={(local) => {
            setOpenLocalModal(false);
            api.post('/usuario_salvar_local.php', { id_local: local.id_local });
          }}
        />
      )}
    </div>
  );
}
