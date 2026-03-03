import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";

import Login from "../apps/operacional/pages/Login.jsx";
import Dashboard from "../apps/operacional/pages/Dashboard.jsx";
import SecurityGuard from "../apps/operacional/security/SecurityGuard.jsx";

export default function AppRouter() {

    return (
        <BrowserRouter future={{ v7_startTransition: true, v7_relativeSplatPath: true }}>
            <Routes>

                <Route path="/" element={<Navigate to="/login" />} />

                <Route path="/login" element={<Login />} />

                <Route
                    path="/operacional"
                    element={
                        <SecurityGuard>
                            <Dashboard />
                        </SecurityGuard>
                    }
                />

            </Routes>
        </BrowserRouter>
    );
}