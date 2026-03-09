import { useRuntimeAuth } from "../../operacional/auth/RuntimeAuthContext";
import { Navigate } from "react-router-dom";

/**
 * SecurityGuard para rotas de Administrador
 * Diferente do SecurityGuard operacional, este não exige contexto operacional
 * pois o admin precisa acessar sem estar vinculado a uma unidade/local específico
 */
export default function AdminGuard({ children }) {
    const { session, loading } = useRuntimeAuth();

    if (loading) {
        return <div>Carregando...</div>;
    }

    // Verifica se tem token (usuário está logado)
    if (!session || !session.token) {
        return <Navigate to="/login" replace />;
    }

    // Não exige contexto operacional para admin
    return children;
}
