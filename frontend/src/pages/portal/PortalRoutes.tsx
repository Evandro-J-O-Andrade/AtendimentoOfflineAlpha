import { Routes, Route } from "react-router-dom";
import PortalHome from "./PortalHome";
import PortalPage from "./PortalPage";

export default function PortalRoutes() {
    return (
        <Routes>
            <Route index element={<PortalHome />} />
            <Route path="home" element={<PortalPage />} />
        </Routes>
    );
}