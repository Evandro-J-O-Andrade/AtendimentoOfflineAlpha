# MAP-004 — Portal & Operational Context Architecture

## Status
Documento Canônico de Arquitetura.
Portal e Contexto Operacional do Midas.

---

## Classificação
```text
Tipo: Foundation Architecture
Camada: Plataforma
Prioridade: Crítica
Obrigatoriedade: Global
```

---

## Objetivo
Definir arquitetura de navegação, entrada, seleção de contexto operacional e acesso aos domínios.

---

## Problema que Resolve
```text
Login entrando direto no HIS
Login entrando direto no CRM
Usuários sem contexto
Navegação inconsistente
Múltiplos pontos de entrada
```

---

## Lei Canônica MAP-004-001
```text
Portal é a entrada oficial da plataforma.
```

---

## Lei Canônica MAP-004-002
```text
Nenhum domínio é acessado diretamente.
```

---

## Lei Canônica MAP-004-003
```text
Login não define contexto.
```

---

## Lei Canônica MAP-004-004
```text
Contexto é selecionado após a entrada no aplicativo.
```

---

## Fluxo Oficial
```text
Login
↓
Portal
↓
Application Registry
↓
Container/App
↓
Contexto Operacional
↓
Dashboard
↓
Operação
```

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Portal é a entrada oficial da plataforma.
```

### LC-004 — JWT não é Fonte da Verdade
```text
JWT é mecanismo de transporte via HttpOnly Cookie.
Fonte da Verdade: Database + Session Store.
Proibido: localStorage, sessionStorage.
```

### LC-005 — SP First Architecture
```text
Frontend → API → Service → Dispatcher → Stored Procedure → Database
```

### LC-006 — Tenant First
```text
Toda operação executa dentro de Tenant → Organização → Unidade → Setor → Local.
```

### LC-009 — IA é Transversal
```text
AI Core atravessa toda plataforma.
Portal AI, HIS AI, CRM AI, RH AI, Finance AI, Analytics AI, Workflow AI.
```

### LC-013 — Application Registry é Obrigatório
```text
Nenhum módulo existe sem registro.
Portal → Registry → App → Contexto → Dashboard
```

### LC-014 — Portal = Hub Corporativo
```text
Portal consolida: Intranet, Chat, AVA, Analytics, Documentos, CRM, HIS, RH.
Portal orquestra, não executa operações.
```

---

## Portal

### Responsabilidades
```text
Autenticação Validada
Home Corporativa
Widgets
Notificações
Pesquisa Global
Apps Registrados
Favoritos
IA Corporativa
```

### Não Responsável Por
```text
Operação Clínica
Operação Financeira
Operação Comercial
Operação RH
```

---

## Application Registry

### Objetivo
Registrar oficialmente todos os aplicativos.

### Estrutura
```text
Application
Version
Owner
Domain
Permissions
Routes
Status
```

### Lei
```text
Nenhuma aplicação existe fora do Registry.
```

---

## Containers

Portal exibe containers navegáveis:

```text
HIS | CRM | RH | Financeiro | Farmácia | Chat | AVA | Intranet
```

---

## Context Selection

Acontece após entrar no aplicativo.

### Exemplo HIS
```text
Portal → HIS → Selecionar Unidade → Selecionar Perfil → Dashboard
```

---

## Context Aggregate

### Entidades
```text
OperationalContext
Organization
Unit
Sector
Role
```

---

## Lei
```text
Toda operação depende de contexto ativo.
```

---

## Dashboards por Domínio

```text
HIS: Dashboard Assistencial
CRM: Dashboard Comercial
RH: Dashboard Pessoas
Financeiro: Dashboard Financeiro
Farmácia: Dashboard Farmacêutico
Analytics: Dashboard Executivo
```

---

## Eventos Oficiais

```text
PortalOpened
AppOpened
ContextSelected
DashboardLoaded
```

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-003 — Identity | Login/Auth |
| MAP-005 — Portal | Portal detalhado |
| MD-020 — Portal Core | Core |
| FRONT-002 — Context Selection | UX |
| FRONT-003 — Portal Experience | Portal UX |