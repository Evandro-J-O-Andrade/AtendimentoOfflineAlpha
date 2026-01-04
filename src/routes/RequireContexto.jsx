import { Navigate } from "react-router-dom";
import { useContextoAtendimento } from "@/context/ContextoAtendimento";
import { useAuth } from "@/context/AuthContext";

export default function RequireContexto({ children }) {
  const { contexto } = useContextoAtendimento();
  const { loading } = useAuth();

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

  // Logado, mas sem contexto → força selecionar
  if (!contexto) {
    return <Navigate to="/contexto" replace />;
  }

  return children;
}
