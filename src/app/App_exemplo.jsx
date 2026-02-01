/**
 * App.jsx - Componente Principal da Aplicação
 * 
 * Estrutura:
 * - BrowserRouter (React Router)
 * - Providers de Context (Auth, Atendimento)
 * - AppRoutes (definição de rotas)
 */

import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import { AtendimentoProvider } from './context/AtendimentoContextoV2';
import AppRoutes from './routes/Routes';
import './App.css';

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <AtendimentoProvider>
          <AppRoutes />
        </AtendimentoProvider>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
