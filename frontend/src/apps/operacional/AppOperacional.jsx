import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";

// Páginas existentes - setores principais
import Dashboard from "./pages/Dashboard";
import Recepcao from "./pages/recepcao/Recepcao";
import Triagem from "./pages/triagem/Triagem";
import Enfermagem from "./pages/enfermagem/Enfermagem";
import Medico from "./pages/medico/Medico";
import Farmacia from "./pages/farmacia/Farmacia";
import Laboratorio from "./pages/laboratorio/Laboratorio";
import Internacao from "./pages/internacao/Internacao";
import Estoque from "./pages/estoque/Estoque";

// Páginas existentes - outros setores
import Ambulancia from "./pages/ambulancia/Ambulancia";
import Remocao from "./pages/remocao/Remocao";
import Manutencao from "./pages/manutencao/Manutencao";
import Gasoterapia from "./pages/gasoterapia/Gasoterapia";
import AssistenciaSocial from "./pages/assistencia_social/AssistenciaSocial";
import Faturamento from "./pages/faturamento/Faturamento";
import Cat from "./pages/cat/Cat";
import Obito from "./pages/obito/Obito";
import Pdv from "./pages/pdv/Pdv";
import Nutricao from "./pages/nutricao/Nutricao";
import Interconsulta from "./pages/interconsulta/Interconsulta";

// Admin
import Admin from "../admin/pages/Admin";
import AdminModulePage from "../admin/pages/AdminModulePage";

// Contexto
import SelecionarContexto from "./pages/contexto/SelecionarContexto";

// Guardas
import SecurityGuard from "./security/SecurityGuard";
import RuntimeActionRouter from "../../runtime/RuntimeActionRouter";

// Páginas das SPs do dump (em pastas)
import Atendimento from "./pages/atendimento/Atendimento";
import ExecutorEvolucao from "./pages/executor/ExecutorEvolucao";
import ExecutorEstoque from "./pages/executor/ExecutorEstoque";
import ExecutorFaturamento from "./pages/executor/ExecutorFaturamento";
import FluxoEstoque from "./pages/fluxo/FluxoEstoque";
import CoordenadorGlobal from "./pages/coordenador/CoordenadorGlobal";

export default function AppOperacional() {
  return (
    <Routes>
      {/* Dashboard */}
      <Route path="/" element={<Dashboard />} />
      
      {/* Rotas de contexto */}
      <Route path="/contexto" element={<SelecionarContexto />} />
      
      {/* Rota runtime dinâmica */}
      <Route path="/runtime/:acao" element={
        <SecurityGuard>
          <RuntimeActionRouter />
        </SecurityGuard>
      } />

      {/* Dashboard redirect */}
      <Route path="/dashboard" element={<Navigate to="/" />} />

      {/* ===== SETORES PRINCIPAIS ===== */}
      <Route path="/recepcao" element={
        <SecurityGuard>
          <Recepcao />
        </SecurityGuard>
      } />
      
      <Route path="/triagem" element={
        <SecurityGuard>
          <Triagem />
        </SecurityGuard>
      } />
      
      <Route path="/enfermagem" element={
        <SecurityGuard>
          <Enfermagem />
        </SecurityGuard>
      } />
      
      <Route path="/medico" element={
        <SecurityGuard>
          <Medico />
        </SecurityGuard>
      } />
      
      <Route path="/farmacia" element={
        <SecurityGuard>
          <Farmacia />
        </SecurityGuard>
      } />
      
      <Route path="/laboratorio" element={
        <SecurityGuard>
          <Laboratorio />
        </SecurityGuard>
      } />
      
      <Route path="/internacao" element={
        <SecurityGuard>
          <Internacao />
        </SecurityGuard>
      } />
      
      <Route path="/estoque" element={
        <SecurityGuard>
          <Estoque />
        </SecurityGuard>
      } />

      {/* ===== OUTROS SETORES ===== */}
      <Route path="/ambulancia" element={
        <SecurityGuard>
          <Ambulancia />
        </SecurityGuard>
      } />
      
      <Route path="/remocao" element={
        <SecurityGuard>
          <Remocao />
        </SecurityGuard>
      } />
      
      <Route path="/manutencao" element={
        <SecurityGuard>
          <Manutencao />
        </SecurityGuard>
      } />
      
      <Route path="/gasoterapia" element={
        <SecurityGuard>
          <Gasoterapia />
        </SecurityGuard>
      } />
      
      <Route path="/assistencia-social" element={
        <SecurityGuard>
          <AssistenciaSocial />
        </SecurityGuard>
      } />
      
      <Route path="/faturamento" element={
        <SecurityGuard>
          <Faturamento />
        </SecurityGuard>
      } />
      
      <Route path="/cat" element={
        <SecurityGuard>
          <Cat />
        </SecurityGuard>
      } />
      
      <Route path="/obito" element={
        <SecurityGuard>
          <Obito />
        </SecurityGuard>
      } />
      
      <Route path="/pdv" element={
        <SecurityGuard>
          <Pdv />
        </SecurityGuard>
      } />
      
      <Route path="/nutricao" element={
        <SecurityGuard>
          <Nutricao />
        </SecurityGuard>
      } />
      
      <Route path="/interconsulta" element={
        <SecurityGuard>
          <Interconsulta />
        </SecurityGuard>
      } />

      {/* ===== SPs DO DUMP ===== */}
      <Route path="/atendimento" element={
        <SecurityGuard>
          <Atendimento />
        </SecurityGuard>
      } />
      
      <Route path="/executor/evolucao" element={
        <SecurityGuard>
          <ExecutorEvolucao />
        </SecurityGuard>
      } />
      
      <Route path="/executor/estoque" element={
        <SecurityGuard>
          <ExecutorEstoque />
        </SecurityGuard>
      } />
      
      <Route path="/executor/faturamento" element={
        <SecurityGuard>
          <ExecutorFaturamento />
        </SecurityGuard>
      } />
      
      <Route path="/fluxo/estoque" element={
        <SecurityGuard>
          <FluxoEstoque />
        </SecurityGuard>
      } />
      
      <Route path="/coordenador/global" element={
        <SecurityGuard>
          <CoordenadorGlobal />
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

      {/* Catch-all */}
      <Route path="*" element={<Navigate to="/" />} />
    </Routes>
  );
}
