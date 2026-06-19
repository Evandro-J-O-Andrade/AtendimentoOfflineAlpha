import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "@/app/providers/AuthProvider";
import { useContextSelection } from "./ContextContext";

export function requireAuth({ children }: { children: React.ReactNode }) {
  const { usuario, loading: authLoading } = useAuth();

  if (authLoading) return <div>Carregando...</div>;
  if (!usuario) return <Navigate to="/login" replace />;

  return <>{children}</>;
}

export function requireContext({ children }: { children: React.ReactNode }) {
  const { usuario, loading: authLoading } = useAuth();
  const { unidade, loading: contextLoading } = useContextSelection();
  const location = useLocation();

  if (authLoading || contextLoading) return <div>Carregando...</div>;
  if (!usuario) return <Navigate to="/login" replace />;
  if (!unidade) return <Navigate to="/contexto" state={{ from: location }} replace />;

  return <>{children}</>;
}