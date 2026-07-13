# FRONT-RUNTIME-MAP

## Objetivo

Documentar o fluxo de runtime frontend que monta a experiência a partir dos contratos do Kernel e do Runtime.

## Fluxo sugerido

Login
↓
AuthProvider (login, mfa)
↓
SessionProvider (session lifecycle)
↓
Context Resolver (resolve contexto do tenant/usuario)
↓
Authorization (policies/roles)
↓
Discovery (features/capabilities disponíveis)
↓
Capability Loader (carrega módulos e componentes dinamicamente)
↓
Navigation Builder (monta rotas e menus runtime-driven)
↓
Portal (render)

## Mapeamento de responsabilidades

- `AuthProvider`: autenticação, renovação de token, MFA
- `SessionProvider`: expiração de sessão, sincronização do contexto
- `ContextResolver`: dados do tenant, preferências, theming
- `Discovery`: endpoint para descobrir capacidades habilitadas
- `Capability Loader`: lazy-load de módulos
- `Navigation Builder`: constrói menu/rotas baseado em capabilities

## Contrato mínimo para componentes

- `LoginExperience` props:
  - `onLoginSuccess(session)`
  - `branding` (logo, colors)
  - `tenantSelection?` (quando aplicável)

## Próximos passos

- Validar providers existentes em `packages/`.
- Especificar contratos de `Discovery` e `Capability Loader`.
- Integrar com `MODEL-LOGICAL-KERNEL.md` quando pronto.
