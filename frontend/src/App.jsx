// ========================================================
// App.jsx - Roteamento Principal e Setup
// ========================================================
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import MainLayout from './components/Layout/MainLayout';

// Pages
import LoginPage from './pages/LoginPage';
import ContextoSelectionPage from './pages/ContextoSelectionPage';
import DashboardPage from './pages/DashboardPage';
import FarmaciaPage from './pages/FarmaciaPage';
import EstoquePage from './pages/EstoquePage';
import AtendimentoPage from './pages/AtendimentoPage';
import FaturamentoPage from './pages/FaturamentoPage';
import RelatoriosPage from './pages/RelatoriosPage';
import PerfilPage from './pages/PerfilPage';

// Admin Pages
import UsuariosPage from './pages/admin/UsuariosPage';
import AuditoriaPage from './pages/admin/AuditoriaPage';
import ManutencaoPage from './pages/admin/ManutencaoPage';
import ConfiguracoesPage from './pages/admin/ConfiguracoesPage';

// Protected Route Component
function ProtectedRoute({ children }) {
  const { usuario, selecionandoContexto, idUnidade, idLocalOperacional } = useAuth();

  // Not authenticated
  if (!usuario) {
    return <Navigate to="/login" replace />;
  }

  // Needs context selection
  if (selecionandoContexto || (!idUnidade || !idLocalOperacional)) {
    return <Navigate to="/contexto" replace />;
  }

  // Authenticated and context selected
  return children;
}

function App() {
  return (
    <Router>
      <AuthProvider>
        <Routes>
          {/* Public Routes */}
          <Route path="/login" element={<LoginPage />} />

          {/* Context Selection Route */}
          <Route path="/contexto" element={<ContextoSelectionPage />} />

          {/* Protected Routes */}
          <Route
            path="/dashboard"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <DashboardPage />
                </MainLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/atendimento"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <AtendimentoPage />
                </MainLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/farmacia"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <FarmaciaPage />
                </MainLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/estoque"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <EstoquePage />
                </MainLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/faturamento"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <FaturamentoPage />
                </MainLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/relatorios"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <RelatoriosPage />
                </MainLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/perfil"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <PerfilPage />
                </MainLayout>
              </ProtectedRoute>
            }
          />

          {/* Admin Routes */}
          <Route
            path="/admin/usuarios"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <UsuariosPage />
                </MainLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/auditoria"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <AuditoriaPage />
                </MainLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/manutencao"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <ManutencaoPage />
                </MainLayout>
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/configuracoes"
            element={
              <ProtectedRoute>
                <MainLayout>
                  <ConfiguracoesPage />
                </MainLayout>
              </ProtectedRoute>
            }
          />

          {/* Default Route */}
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="*" element={<Navigate to="/dashboard" replace />} />
        </Routes>
      </AuthProvider>
    </Router>
  );
}

export default App;
