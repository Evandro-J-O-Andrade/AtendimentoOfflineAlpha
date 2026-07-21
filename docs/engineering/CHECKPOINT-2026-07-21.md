# CHECKPOINT — Frontend Assets & Login Hero

**Data:** 2026-07-21  
**Estado:** Estável após atualização de Vite/Turbo/pnpm

---

## Stack Validada

- **Vite:** 7.3.6 (raiz + apps/portal)
- **Turbo:** 2.10.5 (raiz)
- **pnpm:** 11.10.0 (packageManager field adicionado)
- **React:** 18.3.1
- **TypeScript:** 5.9.3
- **tsx:** 4.23.0

## Estrutura Login

- `apps/portal/src/pages/Login/LoginPage.tsx` — orquestrador
- `apps/portal/src/pages/Login/LoginCard.tsx` — card pai do formulário (direita)
- `apps/portal/src/pages/Login/LoginHero.tsx` — painel esquerdo (hero)
- `apps/portal/src/pages/Login/LoginFooter.tsx` — rodapé
- `apps/portal/src/pages/Login/LoginPage.module.css` — estilos
- `apps/portal/src/pages/Login/ThemeProvider.tsx` — tema

## Assets Públicos

```
apps/portal/public/assets/
├── login/
│   ├── teladelogin.png
│   ├── pagsaas.png
│   ├── pagsaas.webp
│   ├── pagsaas1.webp
│   └── pagsaas3.webp
└── branding/
    ├── logo.png (favicon)
    ├── logoSaaSOriginal.png
    ├── logoSaaSNavbar.png
    ├── logoSaaSHeros.png
    ├── logoSaaSFormulario.png
    ├── logoSaaSFooter.png
    ├── logoSaaS 2.png
    └── logoSemFundo.png
```

## Configurações Atuais

- `index.html` — favicon em `/assets/branding/logo.png`
- `vite.config.ts` — aliases para workspaces + proxy backend
- `tsconfig.base.json` — paths para enterprise packages
- `turbo.json` — tasks de build/lint/typecheck/test/dev

## Próximos Passos Planejados

- Implementar estratégia de assets responsivos por breakpoint + tema (FRONT-084)
- Ajustar tamanho do `.cardForm` em `LoginPage.module.css`
