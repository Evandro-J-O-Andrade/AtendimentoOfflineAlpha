import { Navigate } from "react-router-dom";
import { useApp } from "../../../context/AppContext";

/**
 * Guard para rotas administrativas
 * Baseado em permissões reais
 */
export default function AdminGuard({ children }) {
  const { isAuthenticated, permissoes, loading } = useApp();

  if (loading) return <div>Carregando...</div>;
  if (!isAuthenticated) return <Navigate to="/login" replace />;

  const isAdmin = permissoes?.some((p) => {
    const acao = String(p.acao_frontend || "").toLowerCase();
    const cod = String(p.codigo || "").toUpperCase();
    return acao === "painel_admin" || acao === "adm_dashboard" || cod.includes("ADMIN");
  });

  if (!isAdmin) return <Navigate to="/dashboard" replace />;
  return children;
}
