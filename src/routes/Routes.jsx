/**
 * Routes.jsx - Configuração de Rotas da Aplicação
 * Define todas as rotas públicas, privadas e sua estrutura de acesso
 */

import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';

// PÚBLICAS
import LoginPage from '../pages/login/LoginPage';

// LAYOUTS PRINCIPAIS
import RecepcaoLayout from '../pages/recepcao/RecepcaoLayout';
import TriagemLayout from '../pages/triagem/TriagemLayout';
import ConsultorioLayout from '../pages/consultorio/ConsultorioLayout';
import InternacaoLayout from '../pages/internacao/InternacaoLayout';
import PainelCentralLayout from '../pages/painel/PainelCentralLayout';

// CONTEXTO
import { useAuth } from '../context/AuthContext';
import PrivateRoute from './PrivateRoute';
import AppOperacionalRouter from '@/apps/app_operacional/routes';
import PainelRouter from '@/apps/app_painel/routes';
import TotemRouter from '@/apps/app_totem/routes';

/**
 * AppRoutes - Componente que define toda a estrutura de rotas
 * 
 * Estrutura:
 * - Rota pública: /login
 * - Rotas privadas (requerem autenticação):
 *   - /recepcao - Recepção e registro de pacientes
 *   - /triagem - Triagem de pacientes
 *   - /consultorio - Consultório médico
 *   - /internacao - Internação e evolução de pacientes
 *   - /painel - Painel central de monitoramento
 */
export function AppRoutes() {
  const { usuario } = useAuth();

  return (
    <Routes>
      {/* NOVAS ENTRADAS DE APLICATIVOS */}
      <Route path="/app/*" element={<AppOperacionalRouter />} />
      <Route path="/painel/*" element={<PainelRouter />} />
      <Route path="/totem/*" element={<TotemRouter />} />

      {/* ROTA PÚBLICA */}
      <Route 
        path="/login" 
        element={usuario ? <Navigate to="/recepcao" /> : <LoginPage />} 
      />

      {/* ROTAS PRIVADAS */}
      <Route
        path="/recepcao"
        element={
          <PrivateRoute>
            <RecepcaoLayout />
          </PrivateRoute>
        }
      />

      <Route
        path="/triagem"
        element={
          <PrivateRoute>
            <TriagemLayout />
          </PrivateRoute>
        }
      />

      <Route
        path="/consultorio"
        element={
          <PrivateRoute>
            <ConsultorioLayout />
          </PrivateRoute>
        }
      />

      <Route
        path="/internacao"
        element={
          <PrivateRoute>
            <InternacaoLayout />
          </PrivateRoute>
        }
      />

      <Route
        path="/painel"
        element={
          <PrivateRoute>
            <PainelCentralLayout />
          </PrivateRoute>
        }
      />

      {/* ROTA PADRÃO - Redireciona para login ou recepcao */}
      <Route 
        path="/" 
        element={usuario ? <Navigate to="/recepcao" /> : <Navigate to="/login" />} 
      />

      {/* 404 */}
      <Route path="*" element={<Navigate to="/" />} />
    </Routes>
  );
}

export default AppRoutes;
