/**
 * Portal Application Entry Point
 *
 * @remarks
 * Ponto de entrada da aplicação Portal Enterprise. Renderiza o stack
 * de providers e habilita StrictMode para desenvolvimento.
 *
 * @module main
 *
 * @see {@link ProviderStack} para a árvore de providers.
 */
import React from 'react'
import ReactDOM from 'react-dom/client'
import { ProviderStack } from './app/providers'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ProviderStack />
  </React.StrictMode>
)