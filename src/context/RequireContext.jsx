import { Navigate } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";

export default function RequireContext({ children }) {
  const { authLocal } = useAuth();

  if (!authLocal) {
    return <Navigate to="/login" replace />;
  }

  return children;
}
