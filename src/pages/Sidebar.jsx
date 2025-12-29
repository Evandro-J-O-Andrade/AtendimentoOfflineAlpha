import React, { useState, useEffect } from "react";
import { NavLink, useNavigate } from "react-router-dom";
import {
  FaUserInjured,
  FaClipboardList,
  FaNotesMedical,
  FaPills,
  FaProcedures,
  FaExchangeAlt,
  FaTicketAlt,
  FaUserCog,
  FaKey,
  FaSignOutAlt
} from "react-icons/fa";
import SelectLocalModal from "../components/SelectLocalModal";
import { useAuth } from "../context/AuthContext";
import "./Sidebar.css";

export default function Sidebar({ usuario }) {
  const { authLocal, setAuthLocal, signOut } = useAuth();
  const navigate = useNavigate();

  const [openLocalModal, setOpenLocalModal] = useState(false);

  // Abre modal se usuário não tiver selecionado local e precisa
  useEffect(() => {
    if (
      usuario &&
      (usuario.perfis.includes("RECEPCAO") || usuario.perfis.includes("MEDICO")) &&
      !authLocal
    ) {
      setOpenLocalModal(true);
    }
  }, [usuario, authLocal]);

  const handleLocalSelect = (local) => {
    setAuthLocal(local);
    setOpenLocalModal(false);
    // Redireciona para rota correta
    if (local.tipo === "MEDICO") navigate("/medico/fila");
    else navigate("/recepcao");
  };

  return (
    <>
      <aside className="sidebar">
        <div className="sidebar-header">
          <h2>Pronto Atendimento</h2>
          <span className="perfil">{usuario?.perfil}</span>
        </div>

        <nav className="sidebar-menu">
          {/* RECEPÇÃO */}
          {usuario?.perfis?.includes("RECEPCAO") && (
            <NavLink to="/recepcao" className="menu-item">
              <FaTicketAlt />
              <span>Recepção</span>
            </NavLink>
          )}

          {/* GESTÃO DE USUÁRIOS */}
          {(usuario?.perfis?.includes("ADMIN") || usuario?.perfis?.includes("SUPORTE")) && (
            <NavLink to="/admin/usuarios" className="menu-item">
              <FaUserCog />
              <span>Gestão de Usuários</span>
            </NavLink>
          )}

          {/* FILA */}
          <NavLink to="/fila" className="menu-item">
            <FaClipboardList />
            <span>Fila de Atendimento</span>
          </NavLink>

          {/* SESSÕES */}
          <NavLink to="/account/sessions" className="menu-item">
            <FaKey />
            <span>Sessões</span>
          </NavLink>

          {/* PACIENTE */}
          <NavLink to="/paciente" className="menu-item">
            <FaUserInjured />
            <span>Paciente</span>
          </NavLink>

          {/* MÉDICO */}
          {usuario?.perfil === "MEDICO" && (
            <>
              <div className="menu-section">Ações Médicas</div>

              <NavLink to="/evolucao" className="menu-item">
                <FaNotesMedical />
                <span>Evolução</span>
              </NavLink>

              <NavLink to="/prescricao" className="menu-item">
                <FaPills />
                <span>Prescrição</span>
              </NavLink>

              <NavLink to="/exames" className="menu-item">
                <FaClipboardList />
                <span>Solicitar Exames</span>
              </NavLink>

              <NavLink to="/internacao" className="menu-item">
                <FaProcedures />
                <span>Internação</span>
              </NavLink>

              <NavLink to="/interconsulta" className="menu-item">
                <FaExchangeAlt />
                <span>Interconsulta</span>
              </NavLink>
            </>
          )}
        </nav>

        <div className="sidebar-footer">
          <button className="logout" onClick={signOut}>
            <FaSignOutAlt />
            Sair
          </button>
        </div>
      </aside>

      {/* Modal de escolha de guichê/sala */}
      <SelectLocalModal
        open={openLocalModal}
        perfil={usuario?.perfil || null}
        onClose={() => setOpenLocalModal(false)}
        onSelect={handleLocalSelect}
      />
    </>
  );
}
