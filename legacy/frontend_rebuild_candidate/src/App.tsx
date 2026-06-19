import React, { Suspense } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { useAuth } from "@/app/providers/AuthProvider";

const LoginPage = React.lazy(() => import("@/apps/portal/pages/login/LoginPage"));
const PortalHomePage = React.lazy(() => import("@/apps/portal/pages/PortalHomePage"));
const ManagementDashboardPage = React.lazy(() => import("@/apps/portal/pages/ManagementDashboardPage"));
const AppOperacional = React.lazy(() => import("@/apps/operacional/AppOperacional"));
const AppPainel = React.lazy(() => import("@/apps/painel/AppPainel"));
const AppTotem = React.lazy(() => import("@/apps/totem/AppTotem"));

function PrivateRoute({ children }: { children: React.ReactNode }) {
    const { usuario, loading } = useAuth();
    if (loading) return <div>Carregando...</div>;
    return usuario ? <>{children}</> : <Navigate to="/login" replace />;
}

function AuthRoute({ children }: { children: React.ReactNode }) {
    const { usuario, loading } = useAuth();
    if (loading) return <div>Carregando...</div>;
    if (!usuario) return <>{children}</>;
    return <Navigate to="/portal" replace />;
}

export default function App() {
    return (
        <Router>
            <Suspense fallback={<div>Carregando...</div>}>
                <Routes>
                    <Route path="/" element={<Navigate to="/login" replace />} />
                    <Route path="/login" element={<AuthRoute><LoginPage /></AuthRoute>} />
                    <Route path="/portal" element={<PrivateRoute><PortalHomePage /></PrivateRoute>} />
                    <Route path="/portal/gestao" element={<PrivateRoute><ManagementDashboardPage /></PrivateRoute>} />
                    <Route path="/operacional/*" element={<PrivateRoute><AppOperacional /></PrivateRoute>} />
                    <Route path="/painel/*" element={<PrivateRoute><AppPainel /></PrivateRoute>} />
                    <Route path="/totem/*" element={<PrivateRoute><AppTotem /></PrivateRoute>} />
                    <Route path="*" element={<Navigate to="/login" replace />} />
                </Routes>
            </Suspense>
        </Router>
    );
}