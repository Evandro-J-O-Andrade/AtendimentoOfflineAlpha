import { Navigate, Route, Routes } from "react-router-dom";
import PortalLayout from "../layouts/PortalLayout";
import PortalHomePage from "../pages/PortalHomePage";
import IntranetPage from "../pages/IntranetPage";
import IntegracoesPage from "../pages/IntegracoesPage";
import ManagementDashboardPage from "../pages/ManagementDashboardPage";
import { PortalModuleGate } from "../components/PortalModuleGate";

export default function PortalRoutes() {
    return (
        <Routes>
            <Route element={<PortalLayout />}>
                <Route index element={<PortalHomePage />} />
                <Route
                    path="gestao"
                    element={
                        <PortalModuleGate moduleId="gestao">
                            <ManagementDashboardPage />
                        </PortalModuleGate>
                    }
                />
                <Route
                    path="intranet"
                    element={
                        <PortalModuleGate moduleId="intranet">
                            <IntranetPage />
                        </PortalModuleGate>
                    }
                />
                <Route
                    path="integracoes"
                    element={
                        <PortalModuleGate moduleId="integracoes">
                            <IntegracoesPage />
                        </PortalModuleGate>
                    }
                />
                <Route path="*" element={<Navigate to="/portal" replace />} />
            </Route>
        </Routes>
    );
}