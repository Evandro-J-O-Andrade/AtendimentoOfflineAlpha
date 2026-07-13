import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@atendimentooffline/contracts': path.resolve(__dirname, '../../packages/contracts/src'),
      '@atendimentooffline/api': path.resolve(__dirname, '../../packages/api/src'),
      '@atendimentooffline/auth': path.resolve(__dirname, '../../packages/auth/src'),
      '@atendimentooffline/runtime': path.resolve(__dirname, '../../packages/runtime/src')
    }
  },
  server: {
    port: 3000,
    strictPort: false,
    proxy: {
      '/auth': {
        target: 'http://localhost:3001',
        changeOrigin: true
      },
      '/context': {
        target: 'http://localhost:3001',
        changeOrigin: true
      },
      '/portal': {
        target: 'http://localhost:3001',
        changeOrigin: true
      }
    }
  }
})
