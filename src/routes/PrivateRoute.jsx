import { Navigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";

export default function PrivateRoute({ children, perfisPermitidos }) {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div style={{
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        height: "100vh"
      }}>
        <span>Carregando...</span>
      </div>
    );
  }

  // Não autenticado
  if (!user) {
    return <Navigate to="/login" replace />;
  }

  // Perfil não permitido
  if (
    perfisPermitidos &&
    !perfisPermitidos.some(p => user.perfis?.includes(p))
  ) {
    return <Navigate to="/403" replace />;
  }

  return children;
}
