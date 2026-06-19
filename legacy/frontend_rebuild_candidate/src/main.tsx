import React, { Suspense } from "react";
import ReactDOM from "react-dom/client";
import { AuthProvider } from "@/app/providers/AuthProvider";
import { TenantProvider } from "@/app/providers/TenantProvider";
import { RuntimeProvider } from "@/app/providers/RuntimeContext";
import App from "./App";
import "@/themes/globals.css";

ReactDOM.createRoot(document.getElementById("root")!).render(
    <AuthProvider>
        <TenantProvider>
            <RuntimeProvider>
                <App />
            </RuntimeProvider>
        </TenantProvider>
    </AuthProvider>
);