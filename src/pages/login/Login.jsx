import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import api from "@/services/api";
import SelectLocalModal from "@/components/SelectLocalModal";
import "./Login.css";

export default function Login() {
  const [login, setLogin] = useState("");
  const [senha, setSenha] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const [openLocalModal, setOpenLocalModal] = useState(false);
  const [perfilSelecionado, setPerfilSelecionado] = useState(null);

  const { signIn, setAuthLocal } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const res = await api.post("/auth.php", { login, senha });
      const { token, usuario } = res.data;

      if (!token || !usuario) throw new Error("Resposta inválida da API");

      signIn(token, usuario);

      const perfis = usuario.perfis || [];

      if (perfis.includes("RECEPCAO") || perfis.includes("ADM_RECEPCAO")) {
        setPerfilSelecionado("RECEPCAO");
        setOpenLocalModal(true);
      } else if (perfis.some(p => p.includes("MEDICO"))) {
        setPerfilSelecionado("MEDICO");
        setOpenLocalModal(true);
      } else if (perfis.includes("ADMIN_MASTER") || perfis.includes("SUPORTE")) {
        navigate("/dashboard");
      } else if (perfis.includes("ENFERMAGEM")) {
        navigate("/triagem");
      } else {
        setError("Usuário sem perfil autorizado.");
      }

    } catch (err) {
      setError(err.response?.data?.message || err.message || "Login ou senha inválidos.");
    } finally {
      setLoading(false);
    }
  };

  const handleSelectLocal = (local) => {
    setAuthLocal(local);
    setOpenLocalModal(false);

    if (perfilSelecionado === "MEDICO") navigate("/medico/fila");
    else if (perfilSelecionado === "RECEPCAO") navigate("/recepcao");
    else navigate("/dashboard");
  };

  return (
    <div className="login-page">
      <main className="login-main">
        <form onSubmit={handleSubmit} className="login-card">
          <h3>Acesso ao Sistema</h3>
          {error && <p className="error">{error}</p>}
          <input type="text" value={login} onChange={e => setLogin(e.target.value)} placeholder="Login" required />
          <input type="password" value={senha} onChange={e => setSenha(e.target.value)} placeholder="Senha" required />
          <button type="submit" disabled={loading}>{loading ? "Entrando..." : "Entrar"}</button>
        </form>
      </main>

      <SelectLocalModal
        open={openLocalModal}
        perfil={perfilSelecionado}
        usuario={user}
        onClose={() => setOpenLocalModal(false)}
        onSelect={handleSelectLocal}
      />
    </div>
  );
}
