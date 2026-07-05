# NEW WAVE - RUN GUIDE

## 🚀 OPÇÃO RECOMENDADA: FRONTEND ANTIGO (já funcional)

### Backend + Frontend (simultâneo)
```bash
# Terminal 1 - Backend
cd legacy/backend_antigo
npm run dev

# Terminal 2 - Frontend
cd legacy/frontend_antigo
npm run dev
```

### URLs
- Frontend: http://localhost:5173
- Backend: http://localhost:3001
- Proxy: /api → backend_antigo

---

## 📁 apps/frontend (em desenvolvimento)
- Estrutura Portal OS criada
- Adapters para legacy configurados
- Próximo passo: testar integração

### Rotas do backend já mapeadas:
- /api/auth/login
- /api/auth/refresh  
- /api/auth/me
- /api/auth/contextos
- /api/auth/selecionar-contexto