import { useRuntime } from "@/app/providers/RuntimeContext";
import { Navigate, useLocation } from "react-router-dom";

export default function RequireContext({ children }: { children: React.ReactNode }) {
    const { runtime } = useRuntime();
    const location = useLocation();

    if (!runtime?.id_local_operacional) {
        return <Navigate to="/contexto" state={{ from: location }} replace />;
    }

    return <>{children}</>;
}