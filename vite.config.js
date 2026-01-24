import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), "");

  // DEV: /api/* -> backend php
  // Ex.: VITE_API_PROXY_TARGET=http://prontoatendimento.local
  //      VITE_API_PROXY_REWRITE=/src/api
  const proxyTarget = env.VITE_API_PROXY_TARGET || "http://prontoatendimento.local";
  const proxyRewrite = env.VITE_API_PROXY_REWRITE || "/src/api";

  return {
    plugins: [react()],
    resolve: {
      alias: {
        "@": path.resolve(__dirname, "src"),
      },
    },
    server: {
      proxy: {
        "/api": {
          target: proxyTarget,
          changeOrigin: true,
          secure: false,
          rewrite: (p) => p.replace(/^\/api/, proxyRewrite),
        },
      },
    },
  };
});
