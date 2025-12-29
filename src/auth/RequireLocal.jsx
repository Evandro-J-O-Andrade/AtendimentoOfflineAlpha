import { Navigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";

export default function RequireLocal({ children }) {
  const { localAtual, loading } = useAuth();

  if (loading) return null; // ou spinner

  if (!localAtual) {
    return <Navigate to="/login" replace />;
  }

  return children;
}
