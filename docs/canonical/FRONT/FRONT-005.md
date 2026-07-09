# FRONT-005 — Dashboard Framework

> **Status:** Canônico  
> **Domínio:** FRONT  
> **Tipo:** Framework de Dashboards  
> **Companheiro:** FRONT-000 (Constituição), FRONT-001 (Login), FRONT-002 (Context Selection), FRONT-003 (Portal Enterprise), FRONT-004 (Application Registry), MD-109 (Dashboard Context Framework), MD-134 (Display Event Distribution Engine), MAP-001 (Enterprise Domain Architecture)

---

## 1. Objetivo

Define o framework canônico de dashboards da plataforma SaaS Enterprise.

Dashboards não são telas fixas. São composições executáveis de widgets, definidas em metadata e resolvidas pelo Portal Runtime.

O Dashboard Framework é uma capacidade de plataforma (`packages/`), não uma funcionalidade de um módulo de domínio.

Fluxo canônico:

```text
DashboardContract
    ↓
Dashboard Framework
    ↓
Widget Resolver
    ↓
Layout Engine
    ↓
Widgets renderizados
```

Nenhum widget de dashboard é hardcoded no Portal.

---

## 2. Framework

O Dashboard Framework é a camada que:

- recebe `DashboardContract` do Portal Runtime;
- resolve widgets;
- aplica layout;
- renderiza widgets no shell.

Responsabilidades:

- orquestrar widgets;
- gerenciar layout;
- propagar eventos de widget;
- atualizar widgets via data binding.

O Dashboard Framework **não**:

- define widgets hardcoded;
- acessa banco;
- chama Stored Procedures;
- conhece módulos de domínio;

---

## 3. Contratos

### 3.1 DashboardContract

```typescript
interface DashboardContract {
  id: string
  title: string
  layout: string
  widgets: WidgetContract[]
  applicationId?: string
}
```

Regras:

- `layout` é um identificador de layout canônico (ex.: `grid`, `free`, `stack`).
- `widgets` é a lista ordenada de widgets.
- `applicationId` indica o proprietário do dashboard.

Local: `packages/contracts/src/dashboard/DashboardContract.ts`

### 3.2 WidgetContract

```typescript
interface WidgetContract {
  id: string
  type: string
  title?: string
  config?: Record<string, unknown>
  order?: number
  applicationId?: string
}
```

Regras:

- `type` é o tipo canônico do widget.
- `config` são configurações específicas do widget.
- `order` define a ordem de renderização.

Local: `packages/contracts/src/widget/WidgetContract.ts`

---

## 4. Layout Engine

O Layout Engine é responsável por posicionar widgets no shell.

Layouts canônicos:

```text
grid       → grade responsiva
free       → posicionamento livre
stack      → empilhamento vertical
```

Regras:

- O layout é definido em metadata, não no frontend.
- O Portal não define layouts hardcoded.
- O Layout Engine é uma capacidade de plataforma.

---

## 5. Tipos de Widget

Widgets canônicos do sistema:

```text
notification-center
agenda
clinical-summary
financial-summary
operational-metrics
custom-html
iframe
chart
```

Regras:

- Novos tipos de widget são registrados via Module SDK.
- O Portal não define tipos de widget.
- Cada tipo de widget possui um contrato de configuração específico.

---

## 6. Registration

Widgets são registrados dinamicamente:

```text
Module SDK
    ↓
Widget Registry
    ↓
Dashboard Framework
    ↓
render(widget)
```

Regras:

- Widgets são registrados por tipo.
- O registro acontece durante o carregamento do módulo.
- Widgets sem tipo registrado são ignorados.

---

## 7. Data Binding

Widgets podem receber dados via data binding:

```typescript
interface WidgetBinding {
  widgetId: string
  source: string
  transform?: string
}
```

Regras:

- Data binding é opcional.
- Widgets sem binding são renderizados com dados padrão.
- O Portal não aplica transformações; apenas encaminha o binding.

---

## 8. Eventos

Eventos padronizados emitidos pelo Dashboard Framework:

```text
DASHBOARD_LOADED
WIDGET_LOADED
WIDGET_RENDERED
WIDGET_ERROR
WIDGET_REFRESHED
LAYOUT_CHANGED
```

Esses eventos são publicados no barramento de eventos da plataforma e estarão disponíveis para integração futura com o Event Store.

Nenhum evento específico de domínio (ex.: `HIS_WIDGET_LOADED`) pode ser criado no Dashboard Framework.

---

## 9. Estados

O Dashboard Framework possui os seguintes estados canônicos:

```text
LOADING_DASHBOARD
DASHBOARD_READY
DASHBOARD_ERROR
WIDGET_RELOADING
```

Transições válidas:

```text
LOADING_DASHBOARD
    ↓ (sucesso)
DASHBOARD_READY
    ↓ (falha)
DASHBOARD_ERROR
    ↓ (recarregar widget)
WIDGET_RELOADING
    ↓ (sucesso)
DASHBOARD_READY
```

---

## 10. UX

Requisitos mínimos:

- layout responsivo baseado em grid;
- widgets carregam independentemente;
- loading state por widget;
- erro isolado por widget (falha em um não quebra o dashboard);
- suporte a temas;
- acessibilidade.

---

## 11. Critérios de Aceitação

O Dashboard Framework é aprovado somente quando:

- dashboards são renderizados exclusivamente a partir de `DashboardContract`;
- widgets são renderizados exclusivamente a partir de `WidgetContract[]`;
- layouts são definidos em metadata;
- widgets são registrados dinamicamente;
- falha em um widget não quebra o dashboard;
- todos os tipos vêm de `packages/contracts`;
- o Dashboard Framework não acessa banco, não chama Stored Procedures e não conhece módulos de domínio.

---

## 12. Critérios de Rejeição

O KILO rejeita implementações que:

- definam widgets hardcoded no Portal;
- acessem banco diretamente;
- chamem Stored Procedures do frontend;
- declarem tipos dentro do Dashboard Framework;
- ignorem `packages/api` e chamem `fetch()`/`axios()` diretamente;
- utilizem eventos específicos de domínio;
- criem layouts hardcoded no Portal;
- misturem lógica de módulo de domínio com o Dashboard Framework.

---

## 13. Regra Permanente

```text
Dashboard é composição de metadata + runtime.

Dashboard não é uma tela React fixa.
```

---

## 14. Dependências

### Permitidas

```text
packages/contracts
packages/api
packages/runtime
```

### Proibidas

```text
apps/his
apps/workforce
apps/displays
apps/management
apps/financeiro
apps/crm
apps/chat
apps/ava
apps/intranet
database/
modules/
```

---

## Integrações

| FRONT / MD | Finalidade |
|---|
| FRONT-000 — Frontend Platform Architecture Constitution | Constituição |
| FRONT-003 — Portal Enterprise Experience | Experiência do Portal |
| FRONT-004 — Application Registry | Registro de aplicações |
| MD-020 — Portal Core | Núcleo do Portal |
| MD-109 — Dashboard Context Framework | Framework de dashboards |
| MD-134 — Display Event Distribution Engine | Distribuição de eventos |
| MAP-001 — Enterprise Domain Architecture | Domínios |

---

*Última atualização: 2026-07-07*
