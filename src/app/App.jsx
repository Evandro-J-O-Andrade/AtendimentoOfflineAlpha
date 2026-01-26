import React from 'react'
import { Routes, Route, Navigate } from 'react-router-dom'

import { AuthProvider } from '../features/auth/AuthContext.jsx'
import { ContextoProvider } from '../features/contexto/ContextoAtendimentoContext.jsx'

import LoginPage from '../features/auth/LoginPage.jsx'
import SelecionarContextoPage from '../features/contexto/SelecionarContextoPage.jsx'

import RequireAuth from './guards/RequireAuth.jsx'
import RequireContexto from './guards/RequireContexto.jsx'

import RecepcaoFilaPage from '../modules/operacao/recepcao/RecepcaoFilaPage.jsx'
import RecepcaoComplementoPage from '../modules/operacao/recepcao/RecepcaoComplementoPage.jsx'

import TotemPage from '../modules/painel/totem/TotemPage.jsx'
import SatisfacaoPage from '../modules/painel/satisfacao/SatisfacaoPage.jsx'
import NotFoundPage from '../shared/ui/NotFoundPage.jsx'

export default function App() {
  return (
    <AuthProvider>
      <ContextoProvider>
        <Routes>
          <Route path="/" element={<Navigate to="/login" replace />} />

          <Route path="/login" element={<LoginPage />} />

          <Route
            path="/contexto"
            element={
              <RequireAuth>
                <SelecionarContextoPage />
              </RequireAuth>
            }
          />

          <Route
            path="/operacao/recepcao"
            element={
              <RequireAuth>
                <RequireContexto>
                  <RecepcaoFilaPage />
                </RequireContexto>
              </RequireAuth>
            }
          />

          <Route
            path="/operacao/recepcao/complemento/:idSenha"
            element={
              <RequireAuth>
                <RequireContexto>
                  <RecepcaoComplementoPage />
                </RequireContexto>
              </RequireAuth>
            }
          />

          <Route path="/painel/totem" element={<TotemPage />} />
          <Route path="/painel/satisfacao" element={<SatisfacaoPage />} />

          <Route path="*" element={<NotFoundPage />} />
        </Routes>
      </ContextoProvider>
    </AuthProvider>
  )
}
