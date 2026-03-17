import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

// Páginas
import Login from "../apps/auth/pages/Login.jsx";
import SelecionarContexto from "../apps/operacional/pages/contexto/SelecionarContexto.jsx";
import PainelUsuario from "../apps/painel/pages/PainelUsuario.jsx";
import Admin from "../apps/admin/pages/Admin.jsx";
import AdminModulePage from "../apps/admin/pages/AdminModulePage.jsx";
import Dashboard from "../pages/Dashboard.jsx";

// Páginas operacionais
import Recepcao from "../apps/operacional/pages/recepcao/Recepcao.jsx";
import Triagem from "../apps/operacional/pages/triagem/Triagem.jsx";
import Enfermagem from "../apps/operacional/pages/enfermagem/Enfermagem.jsx";
import Medico from "../apps/operacional/pages/medico/Medico.jsx";
import Farmacia from "../apps/operacional/pages/farmacia/Farmacia.jsx";
import Totem from "../apps/totem/pages/Totem.jsx";
import Painel from "../apps/painel/pages/Painel.jsx";

// Páginas de novos setores
import Laboratorio from "../apps/operacional/pages/laboratorio/Laboratorio.jsx";
import Internacao from "../apps/operacional/pages/internacao/Internacao.jsx";
import Estoque from "../apps/operacional/pages/estoque/Estoque.jsx";

// Novas páginas de setores
import Ambulancia from "../apps/operacional/pages/ambulancia/Ambulancia.jsx";
import Remocao from "../apps/operacional/pages/remocao/Remocao.jsx";
import Manutencao from "../apps/operacional/pages/manutencao/Manutencao.jsx";
import Gasoterapia from "../apps/operacional/pages/gasoterapia/Gasoterapia.jsx";
import AssistenciaSocial from "../apps/operacional/pages/assistencia_social/AssistenciaSocial.jsx";
import Faturamento from "../apps/operacional/pages/faturamento/Faturamento.jsx";
import Cat from "../apps/operacional/pages/cat/Cat.jsx";
import Obito from "../apps/operacional/pages/obito/Obito.jsx";
import Pdv from "../apps/operacional/pages/pdv/Pdv.jsx";
import Nutricao from "../apps/operacional/pages/nutricao/Nutricao.jsx";
import Interconsulta from "../apps/operacional/pages/interconsulta/Interconsulta.jsx";

// Guardas de segurança
import SecurityGuard from "../apps/operacional/security/SecurityGuard.jsx";
import RuntimeActionRouter from "../runtime/RuntimeActionRouter.jsx";

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
                <Route path="/contexto" element={<SelecionarContexto />} />

                {/* Rota curinga baseada em acao_frontend do banco */}
                <Route
                    path="/runtime/:acao"
                    element={
                        <SecurityGuard>
                            <RuntimeActionRouter />
                        </SecurityGuard>
                    }
                />

                {/* Dashboard principal com menu dinâmico */}
                <Route
                    path="/dashboard"
                    element={
                        <SecurityGuard>
                            <Dashboard />
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

                {/* Rotas de novos setores */}
                <Route
                    path="/laboratorio"
                    element={
                        <SecurityGuard>
                            <Laboratorio />
                        </SecurityGuard>
                    }
                />

                <Route
                    path="/internacao"
                    element={
                        <SecurityGuard>
                            <Internacao />
                        </SecurityGuard>
                    }
                />

                <Route
                    path="/estoque"
                    element={
                        <SecurityGuard>
                            <Estoque />
                        </SecurityGuard>
                    }
                />

                {/* Rota de painel de chamadas */}
                <Route path="/painel-chamadas" element={<Painel />} />

                {/* Novas rotas de setores */}
                <Route
                    path="/ambulancia"
                    element={
                        <SecurityGuard acao="painel_ambulancia">
                            <Ambulancia />
                        </SecurityGuard>
                    }
                />
                <Route
                    path="/remocao"
                    element={
                        <SecurityGuard acao="painel_remocao">
                            <Remocao />
                        </SecurityGuard>
                    }
                />
                <Route
                    path="/manutencao"
                    element={
                        <SecurityGuard acao="painel_manutencao">
                            <Manutencao />
                        </SecurityGuard>
                    }
                />
                <Route
                    path="/gasoterapia"
                    element={
                        <SecurityGuard acao="painel_gasoterapia">
                            <Gasoterapia />
                        </SecurityGuard>
                    }
                />
                <Route
                    path="/assistencia-social"
                    element={
                        <SecurityGuard acao="painel_assistencia_social">
                            <AssistenciaSocial />
                        </SecurityGuard>
                    }
                />
                <Route
                    path="/faturamento"
                    element={
                        <SecurityGuard acao="painel_faturamento">
                            <Faturamento />
                        </SecurityGuard>
                    }
                />
                <Route
                    path="/cat"
                    element={
                        <SecurityGuard acao="painel_cat">
                            <Cat />
                        </SecurityGuard>
                    }
                />
                <Route
                    path="/obito"
                    element={
                        <SecurityGuard acao="painel_obito">
                            <Obito />
                        </SecurityGuard>
                    }
                />
                <Route
                    path="/pdv"
                    element={
                        <SecurityGuard acao="painel_pdv">
                            <Pdv />
                        </SecurityGuard>
                    }
                />
                <Route
                    path="/nutricao"
                    element={
                        <SecurityGuard acao="painel_nutricao">
                            <Nutricao />
                        </SecurityGuard>
                    }
                />
                <Route
                    path="/interconsulta"
                    element={
                        <SecurityGuard acao="painel_interconsulta">
                            <Interconsulta />
                        </SecurityGuard>
                    }
                />

                {/* Painel admin */}
                <Route
                    path="/admin"
                    element={
                        <SecurityGuard acao="painel_admin">
                            <Admin />
                        </SecurityGuard>
                    }
                />

                <Route
                    path="/admin/modulo/:moduloId"
                    element={
                        <SecurityGuard acao="painel_admin">
                            <AdminModulePage />
                        </SecurityGuard>
                    }
                />

                {/* Rota catch-all */}
                <Route path="*" element={<Navigate to="/login" />} />
            </Routes>
        </BrowserRouter>
    );
}
