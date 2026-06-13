import React, { Suspense, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider, useAuth } from "@/apps/operacional/auth/AuthProvider";
import { TenantProvider } from "@/app/providers/TenantProvider";
import { RuntimeProvider } from "@/app/providers/RuntimeContext";

const LoginPage = React.lazy(() => import("@/pages/auth/LoginPage"));
const PortalRoutes = React.lazy(() => import("@/pages/portal/PortalRoutes"));
const ContextSelectionPage = React.lazy(() => import("@/apps/contexto/pages/ContextSelectionPage"));
const AppOperacional = React.lazy(() => import("@/features/atendimento/AppOperacional"));
const AppPainel = React.lazy(() => import("@/apps/painel/AppPainel"));
const AppTotem = React.lazy(() => import("@/apps/totem/AppTotem"));

function PrivateRoute({ children }: { children: React.ReactNode }) {
    const { usuario, loading } = useAuth();

    if (loading) {
        return <div>Carregando...</div>;
    }

    return usuario ? <>{children}</> : <Navigate to="/login" replace />;
}

function AuthRoute({ children }: { children: React.ReactNode }) {
    const { usuario, loading } = useAuth();

    if (loading) {
        return <div>Carregando...</div>;
    }

    if (!usuario) {
        return <>{children}</>;
    }

    return <Navigate to="/portal" replace />;
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

                                <Route
                                    path="/login"
                                    element={
                                        <AuthRoute>
                                            <LoginPage />
                                        </AuthRoute>
                                    }
                                />

                                <Route
                                    path="/portal/*"
                                    element={
                                        <PrivateRoute>
                                            <PortalRoutes />
                                        </PrivateRoute>
                                    }
                                />

                                <Route
                                    path="/contexto"
                                    element={
                                        <PrivateRoute>
                                            <ContextSelectionPage />
                                        </PrivateRoute>
                                    }
                                />

                                <Route
                                    path="/operacional/*"
                                    element={
                                        <PrivateRoute>
                                            <AppOperacional />
                                        </PrivateRoute>
                                    }
                                />

                                <Route
                                    path="/painel/*"
                                    element={
                                        <PrivateRoute>
                                            <AppPainel />
                                        </PrivateRoute>
                                    }
                                />

                                <Route
                                    path="/totem/*"
                                    element={
                                        <PrivateRoute>
                                            <AppTotem />
                                        </PrivateRoute>
                                    }
                                />

                                <Route path="*" element={<Navigate to="/login" replace />} />
                            </Routes>
                        </Suspense>
                    </Router>
                </RuntimeProvider>
            </TenantProvider>
        </AuthProvider>
    );
}