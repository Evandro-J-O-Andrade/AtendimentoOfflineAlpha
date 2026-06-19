import React, { Suspense } from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider, useAuth } from "@/app/providers/AuthProvider";
import { TenantProvider } from "@/app/providers/TenantProvider";
import { RuntimeProvider } from "@/app/providers/RuntimeContext";
import "@/themes/globals.css";
import "@/themes/variables.css";

const LoginPage = React.lazy(() => import("@/apps/portal/pages/login/LoginPage"));
const PortalRoutes = React.lazy(() => import("@/apps/portal/routes/PortalRoutes"));
const ContextSelectionPage = React.lazy(() => import("@/apps/contexto/pages/ContextSelectionPage"));
const AppOperacional = React.lazy(() => import("@/features/atendimento/AppOperacional"));

function PrivateRoute({ children }: { children: React.ReactNode }) {
    const { usuario, loading } = useAuth();
    if (loading) return <div>Carregando...</div>;
    return usuario ? <>{children}</> : <Navigate to="/login" replace />;
}

export default function App() {
    return (
        <AuthProvider>
            <TenantProvider>
                <RuntimeProvider>
                    <Router>
                        <Suspense fallback={<div>Carregando...</div>}>
                            <Routes>
                                <Route path="/" element={<Navigate to="/login" replace />} />
                                <Route path="/login" element={<LoginPage />} />
                                <Route path="/portal/*" element={<PrivateRoute><PortalRoutes /></PrivateRoute>} />
                                <Route path="/contexto" element={<PrivateRoute><ContextSelectionPage /></PrivateRoute>} />
                                <Route path="/operacional/*" element={<PrivateRoute><AppOperacional /></PrivateRoute>} />
                                <Route path="*" element={<Navigate to="/login" replace />} />
                            </Routes>
                        </Suspense>
                    </Router>
                </RuntimeProvider>
            </TenantProvider>
        </AuthProvider>
    );
}

ReactDOM.createRoot(document.getElementById("root")!).render(<App />);