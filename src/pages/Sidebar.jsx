import React, { useState, useEffect } from "react";
import { NavLink, useNavigate } from "react-router-dom";
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
      (usuario.perfis.includes("RECEPCAO") || usuario.perfis.includes("MEDICO") || usuario.perfis.includes("ENFERMAGEM")) &&
      !authLocal
    ) {
      setOpenLocalModal(true);
    }
  }, [usuario, authLocal]);

  const handleLocalSelect = (local) => {
    setAuthLocal(local);
    setOpenLocalModal(false);

    // Redireciona conforme perfil
    if (usuario.perfis.includes("MEDICO")) navigate("/medico/fila");
    else if (usuario.perfis.includes("RECEPCAO")) navigate("/recepcao");
    else if (usuario.perfis.includes("ENFERMAGEM")) navigate("/triagem");
  };

  return (
    <>
      <aside className="sidebar">
        <div className="sidebar-header">
          <h2>Pronto Atendimento</h2>
          <span className="perfil">{usuario?.perfil}</span>
        </div>

        <nav className="sidebar-menu">
          {usuario?.perfis?.includes("RECEPCAO") && <NavLink to="/recepcao">Recepção</NavLink>}
          {usuario?.perfis?.includes("MEDICO") && <NavLink to="/medico/fila">Fila Médico</NavLink>}
          {usuario?.perfis?.includes("ENFERMAGEM") && <NavLink to="/triagem">Triagem</NavLink>}
          {(usuario?.perfis?.includes("ADMIN") || usuario?.perfis?.includes("SUPORTE")) && (
            <NavLink to="/admin/usuarios">Gestão de Usuários</NavLink>
          )}
        </nav>

        <div className="sidebar-footer">
          <button onClick={() => setOpenLocalModal(true)}>Alterar Local</button>
          <button onClick={signOut}>Sair</button>
        </div>
      </aside>

      <SelectLocalModal
        open={openLocalModal}
        usuario={usuario}
        onClose={() => setOpenLocalModal(false)}
        onSelect={handleLocalSelect}
      />
    </>
  );
}
