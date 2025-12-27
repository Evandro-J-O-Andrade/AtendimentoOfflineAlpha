import { Navigate } from "react-router-dom";
import { useAuth } from "../auth/AuthContext";

export default function PrivateRoute({ children, perfil }) {
  const { user, loading } = useAuth();

  // Aguarda validação do token no backend
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

  // Autenticado, mas sem perfil permitido
  if (perfil && !user.perfis?.includes(perfil)) {
    return <Navigate to="/403" replace />;
  }

  // Tudo OK
  return children;
}
