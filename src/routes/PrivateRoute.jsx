import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import api from "@/services/api";
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import SelectLocalModal from "@/components/SelectLocalModal";




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

      // Salva token + usuário
      signIn(token, usuario);

      // Garantir que perfis estão em array e uniformizados
      const perfis = (usuario.perfis || []).map(p => p.toUpperCase());

      // Quem precisa escolher local/contexto
      if (perfis.some(p => ["RECEPCAO", "ADM_RECEPCAO"].includes(p))) {
        setPerfilSelecionado("RECEPCAO");
        setOpenLocalModal(true);
      } 
      // Médico
      else if (perfis.some(p => p.includes("MEDICO"))) {
        setPerfilSelecionado("MEDICO");
        setOpenLocalModal(true);
      } 
      // Admin / Suporte / Master
      else if (perfis.some(p => ["ADMIN_MASTER","SUPORTE_MASTER","SUPORTE","MASTER"].includes(p))) {
        navigate("/dashboard");
      } 
      // Enfermagem
      else if (perfis.includes("ENFERMAGEM")) {
        navigate("/triagem");
      } 
      // Auditoria
      else if (perfis.includes("AUDITORIA")) {
        navigate("/auditoria");
      } 
      else {
        setError("Usuário sem perfil autorizado.");
      }

    } catch (err) {
      const msg = err.response?.data?.message || err.message || "Login ou senha inválidos.";
      setError(msg);
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
      <Header />

      <main className="login-main">
        <form onSubmit={handleSubmit} className="login-card">
          <h3>Acesso ao Sistema</h3>

          {error && <p className="error">{error}</p>}

          <div className="form-group">
            <label>Login</label>
            <input type="text" value={login} onChange={e => setLogin(e.target.value)} required />
          </div>

          <div className="form-group">
            <label>Senha</label>
            <input type="password" value={senha} onChange={e => setSenha(e.target.value)} required />
          </div>

          <button type="submit" disabled={loading} className="btn-primary">
            {loading ? "Entrando..." : "Entrar"}
          </button>
        </form>
      </main>

      <Footer />

      <SelectLocalModal
        open={openLocalModal}
        perfil={perfilSelecionado}
        onClose={() => setOpenLocalModal(false)}
        onSelect={handleSelectLocal}
      />
    </div>
  );
}
