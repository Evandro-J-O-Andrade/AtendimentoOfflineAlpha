import SecurityGuard from "../apps/operacional/security/SecurityGuard";
import Dashboard from "../apps/operacional/pages/Dashboard";

<Route
    path="/operacional"
    element={
        <SecurityGuard>
            <Dashboard />
        </SecurityGuard>
    }
/>