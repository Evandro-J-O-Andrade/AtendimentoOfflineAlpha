import { Navigate } from "react-router-dom";
import { useAuth } from "../../app/providers/AuthProvider";

interface Session {
    id_sessao?: number;
}

export default function AdminGuard({ children }: { children: React.ReactNode }) {
    const { session, loading } = useAuth();

    if (loading) return <div>Carregando...</div>;
    if (!(session as Session)?.id_sessao) return <Navigate to="/login" replace />;

    return children;
}