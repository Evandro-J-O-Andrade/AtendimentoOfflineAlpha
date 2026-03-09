import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

// Páginas
import Login from "../apps/operacional/pages/Login.jsx";
import SelecionarContexto from "../apps/operacional/pages/contexto/SelecionarContexto.jsx";
import PainelUsuario from "../apps/painel/pages/PainelUsuario.jsx";
import Admin from "../apps/admin/pages/Admin.jsx";
import AdminModulePage from "../apps/admin/pages/AdminModulePage.jsx";

// Páginas operacionais
import Recepcao from "../apps/operacional/pages/recepcao/Recepcao.jsx";
import Triagem from "../apps/operacional/pages/triagem/Triagem.jsx";
import Enfermagem from "../apps/operacional/pages/enfermagem/Enfermagem.jsx";
import Medico from "../apps/operacional/pages/medico/Medico.jsx";
import Farmacia from "../apps/operacional/pages/farmacia/Farmacia.jsx";
import Totem from "../apps/totem/pages/Totem.jsx";
import Painel from "../apps/painel/pages/Painel.jsx";

// Guardas de segurança
import SecurityGuard from "../apps/operacional/security/SecurityGuard.jsx";
import AdminGuard from "../apps/admin/security/AdminGuard.jsx";

export default function AppRouter() {
    return (
        <BrowserRouter future={{ v7_startTransition: true, v7_relativeSplatPath: true }}>
            <Routes>
                {/* Rota pública - Login */}
                <Route path="/" element={<Navigate to="/login" />} />
                <Route path="/login" element={<Login />} />

                {/* Rota de totem (pública, sem autenticação) */}
                <Route path="/totem" element={<Totem />} />

                {/* Rota de seleção de contexto (após login, antes do painel) */}
                <Route
                    path="/contexto"
                    element={
                        <SecurityGuard>
                            <SelecionarContexto />
                        </SecurityGuard>
                    }
                />

                {/* Páginas operacionais */}
                <Route
                    path="/painel"
                    element={
                        <SecurityGuard>
                            <PainelUsuario />
                        </SecurityGuard>
                    }
                />

                {/* Rota de recepção */}
                <Route
                    path="/recepcao"
                    element={
                        <SecurityGuard>
                            <Recepcao />
                        </SecurityGuard>
                    }
                />

                {/* Rota de triagem */}
                <Route
                    path="/triagem"
                    element={
                        <SecurityGuard>
                            <Triagem />
                        </SecurityGuard>
                    }
                />

                {/* Rota de enfermagem */}
                <Route
                    path="/enfermagem"
                    element={
                        <SecurityGuard>
                            <Enfermagem />
                        </SecurityGuard>
                    }
                />

                {/* Rota de médico */}
                <Route
                    path="/medico"
                    element={
                        <SecurityGuard>
                            <Medico />
                        </SecurityGuard>
                    }
                />

                {/* Rota de farmácia */}
                <Route
                    path="/farmacia"
                    element={
                        <SecurityGuard>
                            <Farmacia />
                        </SecurityGuard>
                    }
                />

                {/* Rota de painel de chamadas */}
                <Route
                    path="/painel-chamadas"
                    element={
                        <Painel />
                    }
                />

                {/* Painel admin - acesso total sem contexto operacional */}
                <Route
                    path="/admin"
                    element={
                        <AdminGuard>
                            <Admin />
                        </AdminGuard>
                    }
                />

                <Route
                    path="/admin/modulo/:moduloId"
                    element={
                        <AdminGuard>
                            <AdminModulePage />
                        </AdminGuard>
                    }
                />

                {/* Rota catch-all */}
                <Route path="*" element={<Navigate to="/login" />} />
            </Routes>
        </BrowserRouter>
    );
}
