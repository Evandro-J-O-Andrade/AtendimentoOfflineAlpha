import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

import { useAuth } from "@/context/AuthContext";
import api from "@/services/api";

import Header from "@/components/Header";
import Footer from "@/components/Footer";
import SelectLocalModal from "@/components/SelectLocalModal";

import "./Login.css";

export default function Login() {
  const [login, setLogin] = useState("");
  const [senha, setSenha] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const [openLocalModal, setOpenLocalModal] = useState(false);
  const [localSelecionado, setLocalSelecionado] = useState(null);
  const [perfilSelecionado, setPerfilSelecionado] = useState(null);

  const { signIn, setAuthLocal } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const response = await api.post("/auth.php", { login, senha });
      const { token, usuario } = response.data;

      if (!token || !usuario) {
        throw new Error("Resposta inválida da API");
      }

      // salva token + usuário
      signIn(token, usuario);

      const perfis = usuario.perfis || [];

      // Perfis que precisam escolher local/contexto
      if (perfis.includes("RECEPCAO") || perfis.includes("MEDICO")) {
        setPerfilSelecionado(perfis.includes("MEDICO") ? "MEDICO" : "RECEPCAO");
        setOpenLocalModal(true);
      }
      // Admin / Gestão / Suporte
      else if (
        perfis.includes("ADMIN") ||
        perfis.includes("GESTAO") ||
        perfis.includes("SUPORTE")
      ) {
        navigate("/dashboard");
      }
      // Enfermagem
      else if (perfis.includes("ENFERMAGEM")) {
        navigate("/triagem");
      }
      // Auditoria
      else if (perfis.includes("AUDITORIA")) {
        navigate("/auditoria");
      } else {
        setError("Usuário sem perfil autorizado.");
      }
    } catch (err) {
      const msg =
        err.response?.data?.message ||
        err.message ||
        "Login ou senha inválidos.";
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  const handleSelectLocal = (local) => {
    setLocalSelecionado(local);
    setAuthLocal(local); // salva contexto (guichê/sala/tipo)
    setOpenLocalModal(false);

    if (perfilSelecionado === "MEDICO") {
      navigate("/medico/fila");
    } else {
      navigate("/recepcao");
    }
  };

  return (
    <div className="login-page">
      <Header />

      <main className="login-main">
        <form onSubmit={handleSubmit} className="login-card">
          <h3>Acesso ao Sistema</h3>

          {error && <p className="error">{error}</p>}

          <div className="form-group">
            <label>Login</label>
            <input
              type="text"
              value={login}
              onChange={(e) => setLogin(e.target.value)}
              required
            />
          </div>

          <div className="form-group">
            <label>Senha</label>
            <input
              type="password"
              value={senha}
              onChange={(e) => setSenha(e.target.value)}
              required
            />
          </div>

          <button type="submit" disabled={loading} className="btn-primary">
            {loading ? "Entrando..." : "Entrar"}
          </button>
        </form>
      </main>

      <Footer />

      {/* Modal de escolha de guichê / sala / contexto */}
      <SelectLocalModal
        open={openLocalModal}
        perfil={perfilSelecionado}
        onClose={() => setOpenLocalModal(false)}
        onSelect={handleSelectLocal}
      />
    </div>
  );
}
