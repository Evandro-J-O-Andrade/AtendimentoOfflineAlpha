import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

import Login from "../apps/operacional/pages/Login.jsx";
import Dashboard from "../apps/operacional/pages/Dashboard.jsx";
import Recepcao from "../apps/operacional/pages/recepcao/Recepcao.jsx";
import Triagem from "../apps/operacional/pages/triagem/Triagem.jsx";
import Medico from "../apps/operacional/pages/medico/Medico.jsx";
import Farmacia from "../apps/operacional/pages/farmacia/Farmacia.jsx";
import Enfermagem from "../apps/operacional/pages/enfermagem/Enfermagem.jsx";

import Painel from "../apps/painel/pages/Painel.jsx";
import Totem from "../apps/totem/pages/Totem.jsx";

import SecurityGuard from "../apps/operacional/security/SecurityGuard.jsx";

export default function AppRouter() {

    return (
        <BrowserRouter future={{ v7_startTransition: true, v7_relativeSplatPath: true }}>
            <Routes>

                {/* Rotas Públicas */}
                <Route path="/" element={<Navigate to="/login" />} />
                <Route path="/login" element={<Login />} />
                <Route path="/painel" element={<Painel />} />
                <Route path="/totem" element={<Totem />} />

                {/* Rotas Operacionais (Protegidas) */}
                <Route
                    path="/operacional"
                    element={
                        <SecurityGuard>
                            <Dashboard />
                        </SecurityGuard>
                    }
                />

                <Route
                    path="/operacional/recepcao"
                    element={
                        <SecurityGuard>
                            <Recepcao />
                        </SecurityGuard>
                    }
                />

                <Route
                    path="/operacional/triagem"
                    element={
                        <SecurityGuard>
                            <Triagem />
                        </SecurityGuard>
                    }
                />

                <Route
                    path="/operacional/medico"
                    element={
                        <SecurityGuard>
                            <Medico />
                        </SecurityGuard>
                    }
                />

                <Route
                    path="/operacional/enfermagem"
                    element={
                        <SecurityGuard>
                            <Enfermagem />
                        </SecurityGuard>
                    }
                />

                <Route
                    path="/operacional/farmacia"
                    element={
                        <SecurityGuard>
                            <Farmacia />
                        </SecurityGuard>
                    }
                />

                {/* Rota Catch-all */}
                <Route path="*" element={<Navigate to="/login" />} />

            </Routes>
        </BrowserRouter>
    );
}
