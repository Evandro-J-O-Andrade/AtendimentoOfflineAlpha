# Frontend Structure — NEW WAVE Enterprise Platform

## Structure
```
src/
├── app/
│   ├── Portal.tsx          # FRONT-001
│   ├── ContextSelector.tsx # FRONT-002  
│   └── Dashboard.tsx       # FRONT-003
├── components/
│   ├── LoginForm.tsx
│   ├── ContextCard.tsx
│   └── DashboardGrid.tsx
├── services/
│   ├── auth.service.ts
│   ├── context.service.ts
│   └── api.service.ts
├── stores/
│   ├── session.store.ts
│   └── context.store.ts
└── hooks/
└── useAuth.ts
```

## Fluxo
```tsx
// Login → ContextSelector → Dashboard
```

## Connection
```tsx
// Connect to ENGINEERING_GRAPH.json
// Validate permissions via MD-permissao
```