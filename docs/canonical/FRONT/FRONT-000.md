# FRONT-000 — Frontend Platform Architecture Constitution

## Status

```text
CANÔNICO
OBRIGATÓRIO
FREEZE 2
DOCUMENTO CONSTITUCIONAL DO FRONTEND
```

Companheiro de: MD-020 (Portal Core), MD-143 (Management Center), MD-144 (Monorepo & Engine), KILO-ENGINE-v8 (Portal & MC Evolution), MD-CANONICO-IA-001 a 004.

---

## 1. Objetivo

Definir as leis arquiteturais obrigatórias para a construção do frontend da plataforma SaaS Enterprise.

O frontend **não** é uma aplicação React única. É uma:

```text
Enterprise Frontend Platform
=
Applications + Platform Packages + Runtime Engines + Contracts + Metadata Driven UI
```

---

## 2. Lei Principal — Portal First Architecture

Todo acesso humano inicia pelo Portal Enterprise.

```text
Pessoa
  ↓
Login
  ↓
Identity Resolution
  ↓
Context Selection
  ↓
Portal Enterprise
  ↓
Applications
```

Nenhuma aplicação quebra esse fluxo (MD-CANONICO-IA-001 Regra 21).

---

## 3. Conceitos Fundamentais — Pessoa ≠ Usuário ≠ Contexto

```text
Pessoa      → Identidade global (raiz)
Usuário     → Permissões dentro de um contexto
Tenant      → Organização
Contexto    → Unidade operacional
```

Exemplo:

```text
Pessoa:   João Silva
Tenant:   Hospital Central
Contexto: Pronto Atendimento
App:      HIS
```

---

## 4. Aplicações são Produtos

```text
apps/
├── portal
├── management
├── his
├── workforce
├── displays
├── intranet
├── chat
├── ava
├── crm
└── financeiro
```

Cada app possui autonomia. `management` é app separado do `portal`.

---

## 5. Packages são Capacidades da Plataforma

```text
packages/
├── ui
├── design-system
├── auth
├── contracts
├── api
├── runtime
├── layout
├── navigation
├── dashboard
├── widgets
├── module-sdk
└── assets
```

### Proibido (FE-001 / MD-144)

Compartilhar telas entre aplicações:

```text
❌ Header.tsx
❌ Sidebar.tsx
❌ DashboardPage.tsx
❌ MenuHospital.tsx
```

Isso cria acoplamento. Compartilha-se **engine**, não componente pronto.

---

## 6. Metadata Driven Frontend

O frontend não conhece regras de negócio. O backend fornece:

```json
{
  "applications": [],
  "menus": [],
  "permissions": [],
  "widgets": [],
  "dashboards": [],
  "branding": []
}
```

O frontend renderiza. O Portal não sabe que existe HIS; recebe o contrato e monta o Application Launcher.

---

## 7. Runtime Architecture

Toda experiência dinâmica possui Runtime:

```text
PortalRuntime · ManagementRuntime · DisplayRuntime · HISRuntime
```

O Runtime monta Shell + Dashboard Framework + Application Launcher a partir do contrato.

---

## 8. Dashboard Framework

Dashboard não é tela fixa; é engine:

```text
Dashboard Framework + Widgets + Layout Engine + Contracts
```

```typescript
interface DashboardContract {
  id: string
  widgets: WidgetContract[]
  layout: string
}
```

```tsx
<DashboardRuntime dashboard={dashboard} />
```

---

## 9. Authentication

```text
❌ JWT em localStorage / sessionStorage
✅ HttpOnly Cookie
```

Fluxo: `AuthProvider → SessionResolver → Identity Context`.

---

## 10. API Communication

Toda comunicação passa por `packages/api`. Nunca `fetch()`/`axios()` espalhado nas telas.

---

## 11. Module SDK

Aplicações entram no ecossistema via contrato:

```typescript
registerModule({ name: "his", routes: [], permissions: [], widgets: [] })
```

O Portal não conhece regras do HIS.

---

## 12. Estrutura Oficial Inicial

```text
enterprise-saas/
├── apps/portal/
├── packages/
│   ├── contracts/  auth/  api/  runtime/  layout/  navigation/
│   └── dashboard/  widgets/  module-sdk/  ui/  design-system/  assets/
├── canonical/FRONT/  FRONT-000.md  FRONT-001.md  FRONT-002.md  FRONT-003.md
├── package.json
├── pnpm-workspace.yaml
├── turbo.json
└── tsconfig.base.json
```

---

## 13. Ordem Obrigatória de Implementação

```text
FRONT-000 (Arquitetura)
  ↓
Contracts
  ↓
Auth Package
  ↓
API Package
  ↓
Portal Runtime
  ↓
Login Experience
  ↓
Context Selection
  ↓
Portal Enterprise
  ↓
Application Container
  ↓
Management Runtime
  ↓
Domain Apps
```

---

## 14. Critérios de Validação KILO

O KILO **rejeita** implementação que:

```text
❌ cria dashboard antes do contexto
❌ cria HIS como página inicial
❌ coloca regra de negócio no Portal
❌ compartilha telas entre apps
❌ usa localStorage para token
❌ cria menu fixo no frontend
❌ cria sidebar universal acoplada
❌ cria componente específico de domínio dentro de packages
```

---

## 15. Fonte de Verdade do Banco

O KILO **não inventa tabelas** pelo frontend. Usa `Dump20260606.sql` (baseline congelado) como evidência:

```text
Banco legado congelado → KILO ENGINE → Inventário → MAPs → MDs → Contracts → Frontend Apps
```

478 tabelas ≠ 478 telas. Organizam-se por Bounded Context → Module → Feature.

---

## Resultado Esperado

```text
        Portal Enterprise
              ↓
        Runtime Platform
   ┌────────┼────────┬────────┬────────┐
 HIS    Workforce  Displays  Chat   Finance
```

Onde Portal é porta de entrada, Contexto vem antes da aplicação, Apps são produtos, Packages são capacidades, backend governa metadata e frontend executa runtime.

---

## Integrações

| MD / FRONT | Finalidade |
|------------|-----------|
| MD-020 — Portal Core | Núcleo do Portal |
| MD-143 — Management Center | MC interno |
| MD-144 — Monorepo & Engine | Estrutura detalhada |
| KILO-ENGINE-v8 | 10 Leis do Portal & MC |
| FRONT-001 — Canonical Login Experience | Login |
| FRONT-002 — Context Selection Experience | Contexto |
| FRONT-003 — Portal Enterprise Experience | Portal |
| ADR-001 → ADR-005 | Decisões arquiteturais |
