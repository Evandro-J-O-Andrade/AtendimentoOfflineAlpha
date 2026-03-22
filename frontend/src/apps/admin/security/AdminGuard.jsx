import { Navigate } from "react-router-dom";
import { useAuth } from "../../operacional/auth/AuthProvider";

/**
 * Guard para rotas administrativas
 * Por enquanto permite acesso se estiver logado
 * TODO: implementar verificação de permissão via API
 */
export default function AdminGuard({ children }) {
  const { session, loading } = useAuth();

  if (loading) return <div>Carregando...</div>;
  if (!session?.id_sessao) return <Navigate to="/login" replace />;

  // Por enquanto, permite tudo - permissões virão do menu
  return children;
}
