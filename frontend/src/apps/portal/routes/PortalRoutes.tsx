import { Navigate, Route, Routes, useParams } from "react-router-dom";
import { PortalModuleGate } from "../components/PortalModuleGate";
import PortalLayout from "../layouts/PortalLayout";
import IntranetPage from "../pages/IntranetPage";
import ManagementDashboardPage from "../pages/ManagementDashboardPage";
import PortalHomePage from "../pages/PortalHomePage";
import ReservedModulePage from "../pages/ReservedModulePage";

function GuardedReservedModulePage() {
  const { moduleId = "" } = useParams();

  return (
    <PortalModuleGate moduleId={moduleId}>
      <ReservedModulePage />
    </PortalModuleGate>
  );
}

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
        <Route path=":moduleId" element={<GuardedReservedModulePage />} />
        <Route path="*" element={<Navigate to="/portal" replace />} />
      </Route>
    </Routes>
  );
}