import { Navigate } from "react-router-dom";
import { useApp } from "../../../context/AppContext";

export default function SecurityGuard({ children, acao }) {
  const { isAuthenticated, contexto, permissoes, loading } = useApp();

  if (loading) return <div>Carregando...</div>;
  if (!isAuthenticated) return <Navigate to="/login" replace />;
  if (!contexto) return <Navigate to="/contexto" replace />;

  if (acao) {
    const tem = (permissoes || []).some(
      (p) =>
        String(p.acao_frontend || "").toLowerCase() ===
        String(acao).toLowerCase()
    );
    if (!tem) {
      return (
        <div style={{ padding: 24, color: "#b91c1c" }}>
          Acesso Negado: você não tem permissão para esta página.
        </div>
      );
    }
  }

  return children;
}
