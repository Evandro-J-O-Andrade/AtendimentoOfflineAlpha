import { Navigate } from "react-router-dom";
import { useApp } from "../../../context/AppContext";

export default function SecurityGuard({ children, acao }) {
  const { isAuthenticated, contexto, permissoes, loading } = useApp();

  if (loading) return <div>Carregando...</div>;
  if (!isAuthenticated) return <Navigate to="/login" replace />;
  if (!contexto) return <Navigate to="/contexto" replace />;

  if (acao) {
    const alvo = String(acao).toLowerCase();
    const tem = (permissoes || []).some((p) => {
      const acaoFrontend = String(p.acao_frontend || "").toLowerCase();
      const codigo = String(p.codigo || "").toUpperCase();

      if (acaoFrontend === alvo) return true;
      // Permissão vinda como "ADMIN" deve liberar painel_admin
      if (alvo === "painel_admin" && codigo === "ADMIN") return true;
      return false;
    });
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
