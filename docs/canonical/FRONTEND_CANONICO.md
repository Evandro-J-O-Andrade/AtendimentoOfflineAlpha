# FRONTEND_CANONICO.md

## Fluxo Obrigatório

```
Login
↓
Portal Corporativo
↓
Aplicação
↓
Contexto Operacional
↓
Dashboard
```

## Estrutura de Pastas Canônica

```text
apps/
├── portal/
│   ├── pages/
│   │   ├── PortalHomePage.tsx
│   │   ├── login/
│   │   │   ├── LoginPage.tsx
│   │   │   └── LoginForm.tsx
│   │   └── ManagementDashboardPage.tsx
│   ├── components/
│   ├── hooks/
│   └── services/
│
├── assistencial/
│   ├── pages/
│   ├── components/
│   ├── hooks/
│   └── services/
│
├── farmacia/
├── financeiro/
├── crm/
├── estoque/
├── bi/
└── administracao/
```

## Packages Comuns

```text
packages/
├── auth/
├── contexto/
├── eventos/
├── workflow/
├── auditoria/
├── sdk/
└── ui/
```

## Regras de Nomenclatura

- **Páginas**: `[Nome]Page.tsx`
- **Componentes**: `PascalCase.tsx`
- **Hooks**: `use[Nome].ts`
- **Serviços**: `[Nome]Service.ts`

## Proibições

- ❌ Login direto para tela assistencial
- ❌ Componentes fora de estrutura canônica
- ❌ Duplicação de lógica de autenticação
- ❌ Acesso a APIs fora do padrão de eventos

## Entry Points

- `src/main.tsx` - Providers globais e renderização
- `src/App.tsx` - Roteamento principal