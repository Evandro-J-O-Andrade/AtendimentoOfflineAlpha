import React, { Suspense } from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider, useAuth } from "./apps/operacional/auth/AuthProvider";
import { TenantProvider } from "./context/TenantProvider";

// Lazy loading dos módulos principais
const AppOperacional = React.lazy(() => import("./apps/operacional/AppOperacional"));
const AppPainel = React.lazy(() => import("./apps/painel/AppPainel"));
const AppTotem = React.lazy(() => import("./apps/totem/AppTotem"));
const PortalRoutes = React.lazy(() => import("./apps/portal/routes/PortalRoutes"));
const PortalLayout = React.lazy(() => import("./apps/portal/layouts/PortalLayout"));
const LoginPage = React.lazy(() => import("./pages/LoginPage"));
const SelecionarContexto = React.lazy(() => import("./apps/operacional/pages/contexto/SelecionarContexto"));

// Rota privada baseada em autenticação
function PrivateRoute({ children }) {
  const { usuario, loading } = useAuth();
  
  if (loading) {
    return <div>Carregando...</div>;
  }
  
  return usuario ? children : <Navigate to="/login" />;
}

export default function App() {
  return (
    <TenantProvider>
      <AuthProvider>
        <Router>
          <Suspense fallback={<div>Carregando...</div>}>
            <Routes>
              <Route path="/" element={<Navigate to="/portal" replace />} />

              {/* Rota de login */}
              <Route path="/login" element={<LoginPage />} />

              {/* Portal Corporativo */}
              <Route
                path="/portal/*"
                element={
                  <PrivateRoute>
                    <Suspense fallback={<div>Carregando Portal...</div>}>
                      <Routes>
                        <Route element={<PortalLayout />}>
                          <Route path="*" element={<PortalRoutes />} />
                        </Route>
                      </Routes>
                    </Suspense>
                  </PrivateRoute>
                }
              />

              {/* Rota de seleção de contexto */}
              <Route 
                path="/contexto" 
                element={
                  <PrivateRoute>
                    <SelecionarContexto />
                  </PrivateRoute>
                } 
              />

              {/* Módulo Operacional */}
              <Route
                path="/operacional/*"
                element={
                  <PrivateRoute>
                    <AppOperacional />
                  </PrivateRoute>
                }
              />

              {/* Módulo Painel */}
              <Route
                path="/painel/*"
                element={
                  <PrivateRoute>
                    <AppPainel />
                  </PrivateRoute>
                }
              />

              {/* Módulo Totem */}
              <Route
                path="/totem/*"
                element={
                  <PrivateRoute>
                    <AppTotem />
                  </PrivateRoute>
                }
              />

              {/* Redireciona qualquer rota desconhecida para o Portal */}
              <Route path="*" element={<Navigate to="/portal" replace />} />
            </Routes>
          </Suspense>
        </Router>
      </AuthProvider>
    </TenantProvider>
  );
}
