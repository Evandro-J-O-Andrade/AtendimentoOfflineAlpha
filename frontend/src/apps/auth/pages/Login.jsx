import React, { useState } from "react";
import { loginFull } from "../../../services/loginService";
import { useApp } from "../../../context/AppContext";

export default function Login() {
  const { login: setAuthContext } = useApp();
  const [usuario, setUsuario] = useState("evandro.andrade");
  const [senha, setSenha] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Função que traduz códigos de erro do backend para mensagens amigáveis
  const traduzirErro = (erro) => {
    if (!erro) return "Erro desconhecido";
    const e = String(erro).toUpperCase();

    if (e.includes("USER_NOT_FOUND") || e.includes("USUARIO_NAO_ENCONTRADO")) 
      return "Usuário não encontrado";
    if (e.includes("INVALID_PASSWORD") || e.includes("SENHA_INCORRETA") || e.includes("SENHA_INVALIDA")) 
      return "Senha incorreta";
    if (e.includes("INACTIVE") || e.includes("USUARIO_INATIVO")) 
      return "Usuário inativo";
    if (e.includes("CONNECTION") || e.includes("CONEXAO")) 
      return "Erro de conexão com o servidor";

    return erro;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (loading) return;

    setLoading(true);
    setError(null);

    try {
      const resultado = await loginFull(usuario, senha, {
        id_sistema: 1,
        id_unidade: 1,
        id_local_operacional: 1
      });

      console.log("Resultado loginFull:", resultado);

      if (!resultado.sucesso) {
        setError(traduzirErro(resultado.erro));
        setLoading(false);
        return;
      }

      // login bem-sucedido → popula contexto global
      setAuthContext(resultado);
      alert(`Login bem-sucedido: ${resultado.usuario.login}`);

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

      <p style={styles.footer}>Evandro Andrade | Sistema de Gestão Hospitalar Alpha</p>
    </div>
  );
}

const styles = {
  container: { minHeight: "100vh", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", background: "linear-gradient(180deg, #f8fafc 0%, #e2e8f0 100%)", padding: "20px" },
  logosContainer: { display: "flex", gap: "30px", marginBottom: "30px", alignItems: "center" },
  logoPrefeitura: { height: "70px", objectFit: "contain" },
  logoAlpha: { height: "50px", objectFit: "contain" },
  card: { background: "#fff", borderRadius: "16px", padding: "40px", width: "100%", maxWidth: "380px", boxShadow: "0 10px 40px rgba(0,0,0,0.1)" },
  title: { textAlign: "center", color: "#1e3a5f", marginBottom: "4px", fontSize: "22px", fontWeight: "700" },
  subtitle: { textAlign: "center", color: "#64748b", marginBottom: "30px", fontSize: "14px", fontWeight: "500" },
  input: { width: "100%", padding: "14px 16px", border: "2px solid #e2e8f0", borderRadius: "10px", fontSize: "15px", marginBottom: "16px", outline: "none", boxSizing: "border-box" },
  button: { width: "100%", padding: "14px", background: "#1e3a5f", color: "#fff", border: "none", borderRadius: "10px", fontSize: "15px", fontWeight: "600", cursor: "pointer", marginTop: "8px" },
  error: { color: "#dc2626", textAlign: "center", marginBottom: "12px", fontSize: "13px", padding: "10px", background: "#fef2f2", borderRadius: "8px" },
  footer: { marginTop: "40px", color: "#64748b", fontSize: "12px", textAlign: "center" }
};
