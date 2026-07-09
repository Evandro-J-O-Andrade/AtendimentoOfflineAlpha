import React from 'react'
import ReactDOM from 'react-dom/client'
import { ProviderStack } from './app/providers'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ProviderStack />
  </React.StrictMode>
)