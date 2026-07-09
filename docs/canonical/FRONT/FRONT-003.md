# FRONT-003 — Portal Enterprise Experience

> **Status:** Canônico  
> **Domínio:** FRONT  
> **Tipo:** Experiência do Portal Enterprise  
> **Companheiro:** FRONT-000 (Constituição), FRONT-001 (Login), FRONT-002 (Context Selection), MD-020 (Portal Core), MD-123 (Portal Canonical Experience), MD-124 (Context First Architecture), MAP-001 (Enterprise Domain Architecture)

---

## 1. Objetivo

Define a experiência canônica do Portal Enterprise da plataforma SaaS Enterprise.

O Portal Enterprise é o produto de entrada do ecossistema. Ele não é uma tela React. Ele é a composição executável do `PortalRuntimeContract`, renderizada pelo `EnterpriseShell` a partir de metadata fornecida pelo backend.

O Portal:

- não conhece módulos de domínio;
- não monta lista fixa de aplicações;
- não define menus hardcoded;
- não avalia permissões;
- não acessa banco;
- não chama Stored Procedures.

O Portal conhece apenas `ApplicationContract`.

Fluxo canônico:

```text
Pessoa
    ↓
Login
    ↓
Identity
    ↓
Contexto
    ↓
Portal Enterprise
    ↓
Aplicações
```

Nunca:

```text
Login
    ↓
HIS
```

Nenhuma aplicação quebra essa ordem (MD-CANONICO-IA-001 Regra 21).

---

## 2. Portal Shell

O Portal Shell é a estrutura base que envolve todo o ecossistema.

Responsabilidades:

- renderizar o branding do Tenant;
- apresentar o contexto ativo;
- exibir a navegação;
- hospedar o Application Launcher;
- hospedar o Dashboard Framework;
- exibir widgets;
- exibir notificações;
- fornecer acesso ao Profile Menu;
- fornecer acesso ao Management Entry (quando habilitado).

O Portal Shell **não**:

- define layout de módulo de domínio;
- conhece HIS, Workforce, Displays, Financeiro, CRM, Chat, AVA, Intranet;
- contém regras de negócio.

---

## 3. Runtime

O Runtime (`packages/runtime`) é a camada que transforma contratos em experiência executável.

Fluxo:

```text
AuthProvider
    ↓
SessionResolver
    ↓
AuthSessionContract
    ↓
ContextResolver
    ↓
ContextContract
    ↓
PortalRuntimeEngine
    ↓
PortalRuntimeContract
    ↓
EnterpriseShell
```

Componentes do Runtime:

- `PortalRuntimeEngine` — monta o `PortalRuntimeContract` a partir de session, context, metadata e grantedPermissions.
- `PortalRuntimeBuilder` — builder fluente para composição do runtime.
- `ContextResolver` — resolve o contexto ativo.
- `ApplicationResolver` — filtra aplicações por `enabled` e permissões.
- `WidgetResolver` — ordena widgets por `order`.
- `NavigationResolver` — filtra itens de navegação por permissões.

O Runtime **não**:

- acessa banco;
- chama Stored Procedures;
- conhece módulos de domínio;
- possui componentes visuais;
- possui JSX de tela;
- possui CSS.

---

## 4. Branding

O branding é um contrato, não uma configuração hardcoded.

```typescript
interface BrandingContract {
  name: string
  logo?: string
  primaryColor?: string
  theme?: 'light' | 'dark' | 'tenant'
}
```

O Portal Shell renderiza o branding exclusivamente a partir do `PortalRuntimeContract.branding`.

Regras:

- Nenhum valor de branding é definido no frontend.
- O branding padrão é `{ name: 'Enterprise Portal' }`.
- O branding do Tenant sobrescreve o padrão.

---

## 5. Navigation

A navegação é metadata, não componente React hardcoded.

```typescript
interface NavigationContract {
  id: string
  label: string
  items: NavigationItemContract[]
}

interface NavigationItemContract {
  id: string
  label: string
  route: string
  permission?: string
}
```

O Portal Shell renderiza a navegação exclusivamente a partir do `PortalRuntimeContract.navigation`.

Regras:

- Nenhum item de menu é definido no frontend.
- Itens sem permissão são filtrados pelo `NavigationResolver`.
- Rotas de módulos de domínio **não são registradas estaticamente**. Elas são registradas dinamicamente pelo Application Registry quando os módulos forem carregados.

---

## 6. Application Launcher

O Application Launcher é o catálogo de aplicações disponíveis para o contexto ativo.

```typescript
interface ApplicationContract {
  id: string
  code: string
  name: string
  icon?: string
  route: string
  category?: string
  enabled: boolean
  licensed?: boolean
  permission?: string
}
```

O Portal Shell renderiza o Application Launcher exclusivamente a partir do `PortalRuntimeContract.applications`.

Regras:

- Nenhuma aplicação é definida no frontend.
- Aplicações são filtradas por `enabled` e permissões pelo `ApplicationResolver`.
- Aplicações desabilitadas não são exibidas.
- Aplicações sem permissão não são exibidas.

---

## 7. Dashboard Framework

O Dashboard Framework é a engine que orquestra widgets em layouts.

```typescript
interface DashboardContract {
  id: string
  title: string
  layout: string
  widgets: WidgetContract[]
}
```

O Portal Shell renderiza o Dashboard Framework exclusivamente a partir do `PortalRuntimeContract.dashboard`.

Regras:

- O dashboard não é uma tela fixa.
- O layout é definido em metadata.
- Os widgets são definidos em metadata.
- Nenhum widget é hardcoded no Portal.

---

## 8. Widgets

Widgets são componentes visuais registrados dinamicamente.

```typescript
interface WidgetContract {
  id: string
  type: string
  title?: string
  config?: Record<string, unknown>
  order?: number
}
```

O Portal Shell renderiza widgets exclusivamente a partir do `PortalRuntimeContract.widgets`.

Regras:

- Nenhum widget é hardcoded no Portal.
- Widgets são ordenados pelo `WidgetResolver`.
- O tipo do widget determina o componente visual a ser renderizado.
- O Portal não conhece a implementação interna do widget.

---

## 9. Notifications

Notificações são parte do contrato do Portal Runtime.

```typescript
interface NotificationContract {
  id: string
  text: string
  read?: boolean
  createdAt?: string
}
```

O Portal Shell renderiza notificações exclusivamente a partir do `PortalRuntimeContract.notifications`.

Regras:

- Nenhuma notificação é hardcoded no Portal.
- Notificações são fornecidas pelo backend ou pelo Runtime.

---

## 10. Context Banner

O Context Banner exibe o contexto ativo no shell.

Informações exibidas:

- Tenant
- Unidade
- Contexto

O Context Banner consome `PortalRuntimeContract.context` e `PortalRuntimeContract.tenant`.

Regras:

- O Context Banner não permite troca de contexto diretamente.
- A troca de contexto é uma ação que navega para `/context`.
- O Context Banner é informacional, não operacional.

---

## 11. Search

A busca é uma capacidade do Portal Shell.

Responsabilidades:

- buscar aplicações por nome, código ou categoria;
- buscar itens de navegação;
- fornecer resultados rápidos.

A busca opera exclusivamente sobre `PortalRuntimeContract.applications` e `PortalRuntimeContract.navigation`.

Regras:

- A busca não acessa banco.
- A busca não acessa módulos de domínio.
- A busca é client-side, operando sobre o contrato já resolvido.

---

## 12. Quick Actions

Quick Actions são atalhos operacionais disponíveis no Portal Shell.

Exemplos:

- Alternar tema (`light` / `dark` / `tenant`);
- Acessar Profile Menu;
- Acessar Management Entry (quando habilitado).

Quick Actions são definidas em metadata ou configuradas estaticamente na camada de shell, nunca em módulo de domínio.

---

## 13. Profile Menu

O Profile Menu exibe informações da pessoa autenticada e fornece ações de sessão.

Informações exibidas:

- Nome da pessoa;
- Cargo/função (se disponível em metadata);
- Tenant atual (se houver).

Ações disponíveis:

- Logout.

O Profile Menu consome `PortalRuntimeContract.user` e ações do `AuthProvider`.

Regras:

- O Profile Menu não altera contexto.
- O Profile Menu não acessa permissões diretamente.
- O Logout é a única ação de sessão exposta no Profile Menu.

---

## 14. Management Entry

O Management Entry é uma porta de acesso opcional para o Management Center.

```typescript
interface ManagementContract {
  enabled: boolean
  containers: ManagementContainerContract[]
}
```

O Management Entry é exibido apenas quando `PortalRuntimeContract.management.enabled === true`.

Regras:

- O Management Entry é um link, não um módulo embutido.
- O Management Center é um app independente (`apps/management`).
- O Portal não conhece a implementação do Management Center.

---

## 15. Eventos

Eventos padronizados emitidos pelo Portal Enterprise:

```text
PORTAL_LOADED
PORTAL_READY
APPLICATION_LAUNCHED
WIDGET_RENDERED
NOTIFICATION_READ
CONTEXT_BANNER_RENDERED
SEARCH_EXECUTED
QUICK_ACTION_TRIGGERED
PROFILE_MENU_OPENED
MANAGEMENT_ENTRY_CLICKED
```

Esses eventos são publicados no barramento de eventos da plataforma e estarão disponíveis para integração futura com o Event Store.

Nenhum evento específico de domínio (ex.: `HIS_OPENED`, `FINANCEIRO_OPENED`) pode ser criado no Portal.

---

## 16. Estados

O Portal Enterprise possui os seguintes estados canônicos:

```text
LOADING_RUNTIME
RUNTIME_READY
RUNTIME_ERROR
CONTEXT_REQUIRED
AUTHENTICATION_REQUIRED
```

Transições válidas:

```text
LOADING_RUNTIME
    ↓ (sucesso)
RUNTIME_READY
    ↓ (falha)
RUNTIME_ERROR
    ↓ (contexto ausente)
CONTEXT_REQUIRED
    ↓ (sessão inválida)
AUTHENTICATION_REQUIRED
```

---

## 17. Responsividade

Requisitos mínimos:

- desktop: layout completo com sidebar + main + widgets;
- tablet: sidebar colapsável, widgets em grid adaptativo;
- mobile: navegação em drawer, widgets em stack, sem dashboard inline.

A responsividade é implementada via CSS e layout engine, sem alteração de contratos ou metadata.

---

## 18. Critérios de Aceitação

O Portal Enterprise é aprovado somente quando:

- o Portal Shell renderiza branding, contexto, navegação, aplicações, dashboard, widgets e notificações exclusivamente a partir do `PortalRuntimeContract`;
- nenhum componente do Portal conhece módulos de domínio;
- nenhuma lista de aplicações é hardcoded;
- nenhum menu é hardcoded;
- nenhum widget é hardcoded;
- nenhuma notificação é hardcoded;
- o Context Banner exibe Tenant, Unidade e Contexto;
- a Search opera sobre aplicações e navegação do contrato;
- o Profile Menu fornece Logout;
- o Management Entry é exibido apenas quando habilitado no contrato;
- todos os tipos vêm de `packages/contracts`;
- a implementação respeita os estados canônicos;
- o Portal não acessa banco, não chama Stored Procedures e não possui regras de negócio.

---

## 19. Critérios de Rejeição

O KILO rejeita implementações que:

- conheçam módulos de domínio (HIS, Workforce, Displays, Financeiro, CRM, Chat, AVA, Intranet);
- montem lista fixa de aplicações;
- montem menu hardcoded;
- acessem banco diretamente;
- chamem Stored Procedures do frontend;
- implementem permissões no Portal;
- declarem tipos dentro de componentes do Portal;
- ignorem `packages/api` e chamem `fetch()`/`axios()` diretamente;
- utilizem eventos específicos de domínio;
- criem estruturas de navegação baseadas em cargo, função, perfil ou setor como diretórios físicos;
- resolvam contexto dentro do Portal;
- redirecionem diretamente para módulos de domínio antes da resolução do contexto.

---

## 20. Regra Permanente

```text
Nenhum componente do Portal pode conhecer um módulo de domínio.

Portal não conhece:
    HIS
    Workforce
    Displays
    Financeiro
    CRM
    Chat
    AVA
    Intranet

Portal conhece apenas:
    ApplicationContract
```

Essa regra é irrevogável e complementa FRONT-000 Seção 6 (Metadata Driven Frontend).

---

## 21. Dependências

### Permitidas

```text
packages/contracts
packages/api
packages/auth
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
| FRONT-001 — Canonical Login Experience | Autenticação |
| FRONT-002 — Canonical Context Selection Experience | Seleção de contexto |
| MD-020 — Portal Core | Núcleo do Portal |
| MD-108 — Operational Context Engine | Motor de contexto |
| MD-120 — Party Identity Architecture | Identidade |
| MD-123 — Portal Canonical Experience | Experiência canônica do Portal |
| MD-124 — Context First Architecture | Contexto primeiro |
| MAP-001 — Enterprise Domain Architecture | Domínios |
| FRONT-004 — Application Registry | Registro de aplicações |
| FRONT-005 — Dashboard Framework | Framework de dashboards |

---

*Última atualização: 2026-07-07*
