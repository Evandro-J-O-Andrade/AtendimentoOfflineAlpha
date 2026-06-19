# BACKEND_CANONICO.md

## Módulos Canônicos

```text
backend/
├── auth/
│   ├── authController.js
│   ├── authMiddleware.js
│   ├── authRoutes.js
│   └── authService.js
│
├── portal/
│   ├── portalController.js
│   ├── portalRoutes.js
│   └── portalService.js
│
├── contexto/
│   ├── contextoController.js
│   ├── contextoRoutes.js
│   └── contextoService.js
│
├── eventos/
│   ├── eventosController.js
│   ├── eventosRoutes.js
│   └── eventosService.js
│
├── auditoria/
│   ├── auditoriaController.js
│   └── auditoriaService.js
│
└── integracoes/
    ├── n8nRoutes.js
    └── integracoesService.js
```

## Contratos de API

### Auth
- `POST /api/auth/login` - Autenticação
- `POST /api/auth/logout` - Encerramento sessão
- `GET /api/auth/me` - Usuário logado

### Portal
- `GET /api/portal/aplicacoes` - Lista aplicações disponíveis
- `GET /api/portal/contextos` - Contextos para aplicação

### Contexto
- `GET /api/contexto/unidades` - Unidades disponíveis
- `GET /api/contexto/locais` - Locais operacionais
- `POST /api/contexto/selecionar` - Selecionar contexto

### Eventos
- `POST /api/eventos` - Registrar evento
- `GET /api/eventos/:id` - Consultar evento

## Regras de Implementação

- Toda requisição passa pelo middleware de autenticação
- Toda requisição tem contexto obrigatório
- Toda operação gera evento
- Toda operação possui auditoria
- Resposta padrão: `{ sucesso, mensagem?, dados? }`