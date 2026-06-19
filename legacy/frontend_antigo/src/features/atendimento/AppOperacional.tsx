import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";

// Guardas de segurança
import SecurityGuard from "@/apps/operacional/security/SecurityGuard";
import RequireContext from "@/components/guards/RequireContext";

// Módulos operacionais - setores principais
import Dashboard from "@/pages/dashboard/Dashboard";
import Recepcao from "@/features/atendimento/Recepcao";
import Triagem from "@/features/atendimento/Triagem";
import Enfermagem from "@/features/atendimento/Enfermagem";
import Medico from "@/features/atendimento/Medico";
import Farmacia from "@/features/farmacia/Farmacia";
import Laboratorio from "@/features/atendimento/Laboratorio";
import Internacao from "@/features/atendimento/Internacao";
import Estoque from "@/features/estoque/Estoque";

// Outros setores
import Ambulancia from "@/features/atendimento/Ambulancia";
import Remocao from "@/features/estoque/Remocao";
import Manutencao from "@/features/administracao/Manutencao";
import Gasoterapia from "@/features/atendimento/Gasoterapia";
import AssistenciaSocial from "@/features/atendimento/AssistenciaSocial";
import Faturamento from "@/features/faturamento/Faturamento";
import Cat from "@/features/administracao/Cat";
import Obito from "@/features/atendimento/Obito";
import Pdv from "@/features/estoque/Pdv";
import Nutricao from "@/features/atendimento/Nutricao";
import Interconsulta from "@/features/atendimento/Interconsulta";

// Admin
import Admin from "@/features/administracao/Admin";
import AdminModulePage from "@/features/administracao/AdminModulePage";

// Contexto
import ContextSelectionPage from "@/apps/contexto/pages/ContextSelectionPage";

/**
 * AppOperacional - New Wave Enterprise
 * Container de rotas para módulos operacionais.
 * Segue LEI CANÔNICA 3: Identidade separada de Contexto Operacional.
 */
export default function AppOperacional() {
  return (
    <Routes>
      {/* Dashboard - tela inicial */}
      <Route path="/" element={<Dashboard />} />
      
      {/* Rotas de contexto - sempre disponíveis */}
      <Route path="/contexto" element={<ContextSelectionPage />} />
      
      {/* ===== SETORES PRINCIPAIS - requerem contexto */}
      <Route path="/recepcao" element={
        <SecurityGuard>
          <RequireContext><Recepcao /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/triagem" element={
        <SecurityGuard>
          <RequireContext><Triagem /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/enfermagem" element={
        <SecurityGuard>
          <RequireContext><Enfermagem /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/medico/*" element={
        <SecurityGuard>
          <RequireContext><Medico /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/farmacia" element={
        <SecurityGuard>
          <RequireContext><Farmacia /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/laboratorio" element={
        <SecurityGuard>
          <RequireContext><Laboratorio /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/internacao" element={
        <SecurityGuard>
          <RequireContext><Internacao /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/estoque" element={
        <SecurityGuard>
          <RequireContext><Estoque /></RequireContext>
        </SecurityGuard>
      } />

      {/* ===== OUTROS SETORES ===== */}
      <Route path="/ambulancia" element={
        <SecurityGuard>
          <RequireContext><Ambulancia /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/remocao" element={
        <SecurityGuard>
          <RequireContext><Remocao /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/manutencao" element={
        <SecurityGuard>
          <Manutencao />
        </SecurityGuard>
      } />
      
      <Route path="/gasoterapia" element={
        <SecurityGuard>
          <RequireContext><Gasoterapia /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/assistencia-social" element={
        <SecurityGuard>
          <RequireContext><AssistenciaSocial /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/faturamento" element={
        <SecurityGuard>
          <RequireContext><Faturamento /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/cat" element={
        <SecurityGuard>
          <RequireContext><Cat /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/obito" element={
        <SecurityGuard>
          <RequireContext><Obito /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/pdv" element={
        <SecurityGuard>
          <RequireContext><Pdv /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/nutricao" element={
        <SecurityGuard>
          <RequireContext><Nutricao /></RequireContext>
        </SecurityGuard>
      } />
      
      <Route path="/interconsulta" element={
        <SecurityGuard>
          <RequireContext><Interconsulta /></RequireContext>
        </SecurityGuard>
      } />

      {/* ===== ADMIN ===== */}
      <Route path="/admin" element={
        <SecurityGuard>
          <Admin />
        </SecurityGuard>
      } />
      
      <Route path="/admin/modulo/:moduloId" element={
        <SecurityGuard>
          <AdminModulePage />
        </SecurityGuard>
      } />

      {/* Catch-all - sempre volta para dashboard */}
      <Route path="*" element={<Navigate to="/" />} />
    </Routes>
  );
}