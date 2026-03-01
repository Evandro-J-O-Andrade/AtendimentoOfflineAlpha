import { useRuntimeAuth } from "../auth/RuntimeAuthContext.jsx";
import { Navigate } from "react-router-dom";

export default function SecurityGuard({ children }) {

    const { session, loading } = useRuntimeAuth();

    if (loading) {
        return <div>Carregando...</div>;
    }

    if (!session) {
        return <Navigate to="/login" replace />;
    }

    return children;
}