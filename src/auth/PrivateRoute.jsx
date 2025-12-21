import { Navigate } from "react-router-dom";
import { useAuth } from "./AuthContext";

export default function PrivateRoute({ children }) {
 const { user, loading } = useAuth(); // <-- MUDAR AQUI para 'user' e 'loading'

 if (loading) { // <-- MUDAR AQUI
 return <div>Carregando...</div>;
 }

 if (!user) { // <-- MUDAR AQUI
 return <Navigate to="/login" replace />;
 }

 return children;
}
