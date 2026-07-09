# FASE 0.1 — Inventário da Estrutura Frontend Real (Revisado)

## Status

**CONCLUÍDO** (revisado com evidência real do repositório em `D:\AtendimentoOfflineAlpha`)

## Origem da Evidência

Este inventário foi gerado a partir da leitura direta da árvore real do projeto
(pnpm workspace definido em `pnpm-workspace.yaml`: `apps/*`, `packages/*`, `backend/*`).

> Nota de governança: a versão anterior deste arquivo referenciava caminhos
> `d:\frontend\...` e afirmava que `packages/` não continha arquivos reais.
> Isso **não corresponde** ao repositório atual. Este documento **substitui**
> a versão anterior. Nenhuma análise visual ou proposta de código está contida aqui.

---

## 1. Estrutura de Diretórios (Evidência Real)

Monorepo pnpm. Raiz: `D:\AtendimentoOfflineAlpha`.

```text
./
├── apps/
│   ├── admin/        (scaffold — src vazio)
│   ├── displays/     (scaffold — src vazio)
│   ├── intranet/     (scaffold — src vazio)
│   ├── mobile/       (scaffold — src vazio)
│   └── portal/       (IMPLEMENTADO — 58 arquivos .ts/.tsx)
└── packages/
    ├── api/                 (5 arquivos)
    ├── auth/                (6 arquivos)
    ├── contracts/           (20 arquivos)
    ├── database/            (vazio)
    ├── enterprise-components/ (vazio)
    ├── enterprise-hooks/    (vazio)
    ├── enterprise-icons/    (1 arquivo)
    ├── enterprise-layout/   (vazio)
    ├── enterprise-sdk/      (vazio)
    ├── enterprise-shell/    (vazio)
    ├── enterprise-theme/    (vazio)
    ├── enums/               (vazio)
    ├── events/              (vazio)
    ├── runtime/             (11 arquivos)
    ├── sdk/                 (vazio)
    ├── types/               (vazio)
    ├── ui/                  (vazio)
    ├── validators/          (vazio)
    └── workflow/            (vazio)
```

---

## 2. Aplicações (`apps/`) Existentes

| Aplicação | Arquivos `.ts/.tsx` | Status      | Evidência                                                   |
| :-------- | :------------------ | :---------- | :---------------------------------------------------------- |
| `portal`  | 58                  | **Implementada** | `apps/portal/src/` com `main.tsx`, `app/`, `shell/`, `runtime/`, `guards/`, `pages/`, `shared/`, `workspaces/` |
| `admin`   | 0                   | Scaffold    | `apps/admin/src` (vazio)                                    |
| `displays`| 0                   | Scaffold    | `apps/displays/src` (vazio)                                 |
| `intranet`| 0                   | Scaffold    | `apps/intranet/src` (vazio)                                 |
| `mobile`  | 0                   | Scaffold    | `apps/mobile/src` (vazio)                                   |

---

## 3. Pacotes (`packages/`) — Implementação Real

| Pacote                        | Arquivos | Status         |
| :---------------------------- | :------- | :------------- |
| `@atendimentooffline/contracts` | 20    | **Implementado** |
| `@atendimentooffline/runtime`   | 11    | **Implementado** |
| `@atendimentooffline/auth`      | 6     | **Implementado** |
| `@atendimentooffline/api`       | 5     | **Implementado** |
| `@atendimentooffline/enterprise-icons` | 1 | Parcial (apenas index) |
| `database`                    | 0        | Scaffold (vazio) |
| `enterprise-components`       | 0        | Scaffold (vazio) |
| `enterprise-hooks`            | 0        | Scaffold (vazio) |
| `enterprise-layout`           | 0        | Scaffold (vazio) |
| `enterprise-sdk`              | 0        | Scaffold (vazio) |
| `enterprise-shell`            | 0        | Scaffold (vazio) |
| `enterprise-theme`            | 0        | Scaffold (vazio) |
| `enums`                       | 0        | Scaffold (vazio) |
| `events`                      | 0        | Scaffold (vazio) |
| `sdk`                         | 0        | Scaffold (vazio) |
| `types`                       | 0        | Scaffold (vazio) |
| `ui`                          | 0        | Scaffold (vazio) |
| `validators`                  | 0        | Scaffold (vazio) |
| `workflow`                    | 0        | Scaffold (vazio) |

---

## 4. Componentes Principais (Inventário)

| Componente        | Local (Evidência)                                      | Responsabilidade (Fato)                                                                  |
| :---------------- | :----------------------------------------------------- | :--------------------------------------------------------------------------------------- |
| **EnterpriseShell** | `apps/portal/src/shell/EnterpriseShell.tsx`          | Renderiza header/nav/main a partir de `PortalRuntimeContract` (branding, tenant, context, user, navigation, applications, widgets, notifications). **Não** consome o pacote `@atendimentooffline/enterprise-shell`. |
| **PortalRuntime** | `apps/portal/src/shell/PortalRuntime.tsx`             | Cria `PortalRuntimeContext`, `PortalRuntimeProvider` e o hook `usePortalRuntime`. Disponibiliza `PortalRuntimeContract` via React context. (Há também o engine em `packages/runtime`.) |
| **AuthProvider**  | `packages/auth/src/AuthProvider.tsx` (export em `index.ts`) | Contexto de autenticação. Exporta `AuthProvider`, `AuthContext`, `useAuth`. Acompanha `SessionResolver`, `AuthGuard`, `AuthSessionContract`. |
| **Widget rendering** | `apps/portal/src/shell/EnterpriseShell.tsx` (linhas 111-130) | **FATO:** `rt.widgets` é renderizado como `<div>` genérico (title/type). **Não existe** `WidgetRenderer` mapeando `widget.type` → componente específico (MetricWidget/ChartWidget/TableWidget) em nenhum pacote ou app. |
| **Layouts**       | `apps/portal/src/shell/EnterpriseShell.tsx`           | Layout definido inline via `React.CSSProperties`. Pacote `@atendimentooffline/enterprise-layout` está **vazio**. |
| **Providers**     | `packages/auth`, `apps/portal/src/shell`, `apps/portal/src/app/router` | `AuthProvider` (auth), `PortalRuntimeProvider` (shell), `RouterProvider` (router). |
| **Hooks**         | `packages/auth/src/hooks/useAuth.ts`, `apps/portal/src/runtime/usePortalRuntime.ts`, `apps/portal/src/app/router.tsx` | `useAuth`, `usePortalRuntime` (re-exporta shell), `useRouter`. Pacote `enterprise-hooks` está **vazio**. |
| **Services**      | `packages/api/src/portal/PortalApi.ts`               | `PortalApi` expõe `runtime`, `navigation`, `applications`, `branding`, `dashboard`, `widgets`, `notifications` contra a API backend. |

---

## 5. Contratos Existentes (`packages/contracts/src`)

Todos definidos e re-exportados em `packages/contracts/src/index.ts`:

| Contrato                  | Arquivo                                      |
| :------------------------ | :------------------------------------------- |
| `WidgetContract`          | `widget/WidgetContract.ts`                   |
| `DashboardContract`       | `dashboard/DashboardContract.ts`             |
| `PortalRuntimeContract`   | `portal/PortalRuntimeContract.ts`            |
| `NavigationContract`      | `navigation/NavigationContract.ts`           |
| `ApplicationContract`     | `application/ApplicationContract.ts`         |
| `BrandingContract`        | `branding/BrandingContract.ts`               |
| `NotificationContract`    | `notification/NotificationContract.ts`       |
| `ManagementContract`      | `portal/ManagementContract.ts`               |
| `ContextContract`         | `context/ContextContract.ts`                 |
| `ContextSelectionContract`| `context/ContextSelectionContract.ts`        |
| `TenantContract`          | `tenant/TenantContract.ts`                   |
| `PermissionContract`      | `permission/PermissionContract.ts`           |
| `AuthSessionContract`     | `auth/AuthSessionContract.ts`                |
| `LoginRequestContract`    | `auth/LoginRequestContract.ts`               |
| `PersonContract`          | `identity/PersonContract.ts`                 |
| `UserContract`            | `identity/UserContract.ts`                   |

### Forma de `WidgetContract` (evidência literal)

```ts
export interface WidgetContract {
  id: string
  type: string
  title: string
  config?: Record<string, unknown>
  order?: number
}
```

### Forma de `PortalRuntimeContract` (evidência literal)

```ts
export interface PortalRuntimeContract {
  user: PersonContract | null
  tenant: TenantContract | null
  context: ContextContract | null
  applications: ApplicationContract[]
  navigation: NavigationContract[]
  widgets: WidgetContract[]
  dashboard?: DashboardContract
  branding: BrandingContract
  notifications?: NotificationContract[]
  management?: ManagementContract
  permissions: string[]
}
```

---

## 6. Componentes de UI Existentes

- **Local (app):** `apps/portal/src/shared/` contém `Button`, `Input`, `Modal`, `Card`, `Table`, `Tabs`, `Calendar`, `DatePicker`, `Toast`, `Dialog` — **todos stubs** (`export const X = () => null`, ver `apps/portal/src/shared/index.ts`).
- **Pacote `@atendimentooffline/ui`**: **vazio**.
- **Pacote `@atendimentooffline/enterprise-components`**: **vazio**.
- **Pacote `@atendimentooffline/enterprise-theme`**: **vazio**.
- **Pacote `@atendimentooffline/enterprise-icons`**: 1 arquivo (apenas index).

---

## 7. Workspaces (`apps/portal/src/workspaces`)

Oito papéis definidos, cada um com `dashboard.tsx`, `layout.tsx`, `routes.ts`, `settings.ts`:

`administrador`, `farmacia`, `financeiro`, `medico`, `operador`, `paciente`, `recepcao`, `ti`.

**FATO:** `dashboard.tsx` e `settings.ts` de todos os oito papéis são stubs (`export default {}`).
Nenhum dashboard por papel está implementado. O padrão de arquivo por papel (ex.: `medico/dashboard.tsx`)
existe hoje como código-fixo por role, ainda não materializado.

---

## 8. Dependências (Consumo)

- `apps/portal/src/main.tsx` → `ProviderStack` (`apps/portal/src/app/providers.tsx`).
- `ProviderStack` compõe:
  `AuthProvider` (`@atendimentooffline/auth`)
  → `PortalRuntimeComposer` (usa `PortalRuntimeEngine` de `@atendimentooffline/runtime` + `createPortalApi` de `@atendimentooffline/api`)
  → `RouterProvider`
  → `NavigationController` (renderiza `LoginPage` / `ContextSelectionPage` / `EnterpriseShell`).
- `PortalRuntimeComposer` (`apps/portal/src/app/providers.tsx:59`):
  - compõe runtime local via `engine.compose(...)`;
  - em seguida busca `portalApi.runtime(idSessao)` e preenche `PortalRuntimeProvider`.
- `EnterpriseShell` consome `usePortalRuntime()` e `useAuth()`.
- **FATO:** `apps/portal` **não importa** os pacotes `enterprise-shell`, `ui`, `enterprise-components`, `enterprise-layout`, `enterprise-theme`, `enterprise-hooks`. O código de apresentação vive localmente em `apps/portal/src`.

---

## Conclusão (Apenas Fatos)

1. O **kernel runtime-driven existe e está conectado**: `contracts` + `runtime` (engine/builder/resolvers) + `auth` + `api` alimentam `PortalRuntimeProvider` dentro de `apps/portal`.
2. A **camada de apresentação está em estado inicial**: `EnterpriseShell` renderiza os contratos de forma genérica (widgets como `<div>`); o UI kit local e os 8 workspaces são stubs; os pacotes compartilhados `enterprise-*` estão vazios.
3. **Não existe** `WidgetRenderer` tipado: `WidgetContract.type` ainda não possui mapeamento para componente visual específico.
4. As demais `apps/` (`admin`, `displays`, `intranet`, `mobile`) são scaffolds sem código.

**Aprovação do inventário pendente para iniciar a FASE 1 (Análise Visual → `frontend-analysis.md`).**
