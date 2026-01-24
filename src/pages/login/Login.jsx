import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";
import api from "@/services/api";
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import "./Login.css";

export default function Login() {
  const [login, setLogin] = useState("");
  const [senha, setSenha] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const { signIn } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      // Endpoint de login (wrapper em /api/auth/auth.php)
      const res = await api.post("/auth/auth.php", { login, senha });
      const { token, usuario } = res.data;

      if (!token || !usuario) throw new Error("Resposta inválida da API");

      signIn(token, usuario);

      const perfis = (usuario.perfis || []).map((p) => String(p).toUpperCase());

      // Admin puro pode ir direto.
      if (perfis.some((p) => ["ADMIN_MASTER", "SUPORTE_MASTER", "SUPORTE", "MASTER"].includes(p)) && perfis.length === 1) {
        navigate("/dashboard");
      } else {
        // Fluxo padrão: seleciona perfil + local
        navigate("/contexto");
      }
    } catch (err) {
      const msg = err.response?.data?.message || err.message || "Login ou senha inválidos.";
      setError(msg);
    } finally {
      setLoading(false);
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
            <input type="text" value={login} onChange={(e) => setLogin(e.target.value)} required />
          </div>

          <div className="form-group">
            <label>Senha</label>
            <input type="password" value={senha} onChange={(e) => setSenha(e.target.value)} required />
          </div>

          <button type="submit" disabled={loading} className="btn-primary">
            {loading ? "Entrando..." : "Entrar"}
          </button>
        </form>
      </main>

      <Footer />
    </div>
  );
}
