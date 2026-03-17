import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { loginService } from "../../../services/loginService";
import { useApp } from "../../../context/AppContext";

export default function Login() {
  const {
    login: setAuthContext,
    setContextosDisponiveis,
    setPermissoes,
    selecionarContexto,
  } = useApp();
  const navigate = useNavigate();
  const [usuario, setUsuario] = useState("");
  const [senha, setSenha] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const traduzirErro = (erro) => {
    if (!erro) return "Erro desconhecido";
    const e = String(erro).toUpperCase();
    if (e.includes("USER_NOT_FOUND") || e.includes("USUARIO_NAO_ENCONTRADO")) return "Usuário não encontrado";
    if (e.includes("INVALID_PASSWORD") || e.includes("SENHA_INCORRETA") || e.includes("SENHA_INVALIDA")) return "Senha incorreta";
    if (e.includes("INACTIVE") || e.includes("USUARIO_INATIVO")) return "Usuário inativo";
    if (e.includes("CONNECTION") || e.includes("CONEXAO")) return "Erro de conexão com o servidor";
    return erro;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (loading) return;
    setLoading(true);
    setError(null);

    try {
      const sessao = await setAuthContext(usuario, senha);

      if (!sessao?.sucesso) {
        setError(traduzirErro(sessao?.erro));
        setContextosDisponiveis(sessao?.contextos || []);
        setLoading(false);
        if (sessao?.erro === "SELECIONE_CONTEXTO") {
          navigate("/contexto", { replace: true });
        }
        return;
      }

      setContextosDisponiveis(sessao.contextos || []);

      const ctxUnico = sessao.contextos?.length === 1 ? sessao.contextos[0] : null;
      if (ctxUnico) {
        selecionarContexto(ctxUnico);
        setPermissoes(ctxUnico.permissoes || []);
        const temPainelAdmin = (ctxUnico.permissoes || []).some(
          (p) => String(p.acao_frontend || "").toLowerCase() === "painel_admin"
        );
        navigate(temPainelAdmin ? "/admin" : "/dashboard", { replace: true });
        setLoading(false);
        return;
      }

      navigate("/contexto", { replace: true });
    } catch (err) {
      console.error(err);
      setError(traduzirErro(err.message || err));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={styles.container}>
      <div style={styles.logosContainer}>
        <img src="/assets/img/prefeitura.png" alt="Prefeitura" style={styles.logoPrefeitura} />
        <img src="/assets/img/sistema.png" alt="Alpha" style={styles.logoAlpha} />
      </div>

      <div style={styles.card}>
        <h1 style={styles.title}>Hospital Guido Guido</h1>
        <p style={styles.subtitle}>Pronto Atendimento Alpha</p>

        <form onSubmit={handleSubmit}>
          <input
            type="text"
            placeholder="Usuário"
            value={usuario}
            onChange={(e) => setUsuario(e.target.value)}
            style={styles.input}
            required
          />
          <input
            type="password"
            placeholder="Senha"
            value={senha}
            onChange={(e) => setSenha(e.target.value)}
            style={styles.input}
            required
          />

          {error && <p style={styles.error}>{error}</p>}

          <button type="submit" style={styles.button} disabled={loading}>
            {loading ? "Conectando..." : "Entrar"}
          </button>
        </form>
      </div>

      <p style={styles.footer}>Sistema de Gestão Hospitalar Alpha</p>
    </div>
  );
}

const styles = {
  container: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    justifyContent: "center",
    minHeight: "100vh",
    background: "linear-gradient(135deg, #e2e8f0, #f8fafc)",
    color: "#0f172a",
    fontFamily: "Inter, system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
    padding: "24px",
  },
  logosContainer: {
    display: "flex",
    gap: "32px",
    alignItems: "center",
    marginBottom: "32px",
  },
  logoPrefeitura: { height: "70px", objectFit: "contain" },
  logoAlpha: { height: "70px", objectFit: "contain" },
  card: {
    width: "100%",
    maxWidth: "420px",
    background: "#ffffff",
    border: "1px solid #e2e8f0",
    borderRadius: "16px",
    padding: "32px",
    boxShadow: "0 20px 60px rgba(15,23,42,0.12)",
  },
  title: { fontSize: "28px", margin: 0, marginBottom: "8px", fontWeight: 700, color: "#0f172a" },
  subtitle: { margin: 0, marginBottom: "24px", color: "#334155" },
  input: {
    width: "100%",
    padding: "14px 16px",
    marginBottom: "12px",
    borderRadius: "10px",
    border: "1px solid #cbd5e1",
    background: "#f8fafc",
    color: "#0f172a",
    fontSize: "15px",
    outline: "none",
  },
  button: {
    width: "100%",
    padding: "14px 16px",
    marginTop: "4px",
    borderRadius: "10px",
    border: "none",
    background: "#0ea5e9",
    color: "#f8fafc",
    fontSize: "16px",
    fontWeight: 700,
    cursor: "pointer",
  },
  error: { color: "#b91c1c", marginBottom: "8px" },
  footer: { marginTop: "20px", color: "#475569" },
};
