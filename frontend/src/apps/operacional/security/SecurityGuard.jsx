import { useRuntimeAuth } from "../auth/RuntimeAuthContext.jsx";
import { Navigate } from "react-router-dom";

export default function SecurityGuard({ children }) {

    const { session, loading, hasOperationalContext } = useRuntimeAuth();

    if (loading) {
        return <div>Carregando...</div>;
    }

    if (!session || !hasOperationalContext) {
        return <Navigate to="/login" replace />;
    }

    return children;
}
