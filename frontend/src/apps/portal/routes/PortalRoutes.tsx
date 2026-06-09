import { Navigate, Route, Routes } from "react-router-dom";
import { PortalLayout } from "../layouts/PortalLayout";
import { PortalHome } from "../pages/PortalHome";
import { IntranetPage } from "../pages/intranet/IntranetPage";
import { TreinamentosPage } from "../pages/treinamentos/TreinamentosPage";
import { DocumentosPage } from "../pages/documentos/DocumentosPage";
import { ChamadosPage } from "../pages/chamados/ChamadosPage";
import { GestaoPage } from "../pages/gestao/GestaoPage";

/** Rotas internas do Portal Corporativo (montadas em /portal/*). */
export function PortalRoutes() {
  return (
    <Routes>
      <Route element={<PortalLayout />}>
        <Route index element={<PortalHome />} />
        <Route path="intranet" element={<IntranetPage />} />
        <Route path="treinamentos" element={<TreinamentosPage />} />
        <Route path="documentos" element={<DocumentosPage />} />
        <Route path="chamados" element={<ChamadosPage />} />
        <Route path="gestao" element={<GestaoPage />} />
        <Route path="*" element={<Navigate to="/portal" replace />} />
      </Route>
    </Routes>
  );
}
