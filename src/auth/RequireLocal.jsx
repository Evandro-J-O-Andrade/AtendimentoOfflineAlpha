import { Navigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";

export default function RequireLocal({ children }) {
  const { localAtual, loading } = useAuth();

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

  // Usuário logado mas sem local definido
  if (!localAtual) {
    return <Navigate to="/select-local" replace />;
  }

  return children;
}
