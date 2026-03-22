import { Navigate } from "react-router-dom";
import { useAuth } from "../auth/AuthProvider";

export default function SecurityGuard({ children }) {
  const { session, loading } = useAuth();

  if (loading) return <div>Carregando...</div>;
  if (!session?.id_sessao) return <Navigate to="/login" replace />;
  if (!session?.contexto_definido) return <Navigate to="/contexto" replace />;

  // Por enquanto, permite tudo - permissões virão do menu
  // TODO: implementar verificação de permissão via API

  return children;
}
