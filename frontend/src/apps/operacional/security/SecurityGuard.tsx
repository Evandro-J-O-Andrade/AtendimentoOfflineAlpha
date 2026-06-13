import { Navigate } from "react-router-dom";
import { useAuth } from "../auth/AuthProvider";

interface Session {
    id_sessao?: number;
    contexto_definido?: boolean;
}

export default function SecurityGuard({ children }: { children: React.ReactNode }) {
    const { session, loading } = useAuth();

    if (loading) return <div>Carregando...</div>;
    if (!(session as Session)?.id_sessao) return <Navigate to="/login" replace />;
    if (!(session as Session)?.contexto_definido) return <Navigate to="/contexto" replace />;

    return children;
}