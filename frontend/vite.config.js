import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { fileURLToPath, URL } from 'node:url'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
      '@/apps': fileURLToPath(new URL('./src/apps', import.meta.url)),
      '@/app': fileURLToPath(new URL('./src/app', import.meta.url)),
      '@/context': fileURLToPath(new URL('./src/context', import.meta.url)),
      '@/pages': fileURLToPath(new URL('./src/pages', import.meta.url)),
      '@/components': fileURLToPath(new URL('./src/components', import.meta.url)),
      '@/services': fileURLToPath(new URL('./src/services', import.meta.url)),
      '@/hooks': fileURLToPath(new URL('./src/hooks', import.meta.url)),
      '@/types': fileURLToPath(new URL('./src/types', import.meta.url)),
      '@/features': fileURLToPath(new URL('./src/features', import.meta.url)),
      '@/shared': fileURLToPath(new URL('./src/shared', import.meta.url)),
      '@/shell': fileURLToPath(new URL('./shell', import.meta.url)),
      '@/providers': fileURLToPath(new URL('./providers', import.meta.url)),
      '@/routes': fileURLToPath(new URL('./routes', import.meta.url)),
      '@/stores': fileURLToPath(new URL('./stores', import.meta.url)),
      '@/assets': fileURLToPath(new URL('./assets', import.meta.url)),
      '@/themes': fileURLToPath(new URL('./src/themes', import.meta.url)),
      '@/config': fileURLToPath(new URL('./config', import.meta.url)),
      '@/constants': fileURLToPath(new URL('./constants', import.meta.url))
    }
  },
  server: {
    proxy: {
      "/api": {
        target: "http://127.0.0.1:3001",
        changeOrigin: true,
        rewrite: (apiPath) => apiPath.replace(/^\/api/, "/api")
      }
    }
  }
})