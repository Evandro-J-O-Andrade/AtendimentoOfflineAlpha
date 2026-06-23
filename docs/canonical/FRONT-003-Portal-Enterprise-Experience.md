# FRONT-003 — Portal Enterprise Experience

## Status

Documento Canônico de Frontend.
Define a experiência do Portal Corporativo.

---

## Objetivo

Transformar o Portal na experiência unificada da plataforma: um ponto de entrada elegante, produtivo e informativo.

---

## Princípio Fundamental

```text
Portal é a porta única.
Portal é a Home.
Nenhuma app operacional abre sem passar pelo Portal.
Nenhum módulo é acessado por URL direta.
```

---

## Fluxo Canônico

```
Login (FRONT-001)
  ↓
Context Selection (FRONT-002)
  ↓
Portal Corporativo (este documento)
  ↓
  ├── App Launcher (apps autorizadas)
  ├── Busca Global (pesquisa unificada)
  ├── Notificações (inbox unificado)
  ├── Favoritos (apps mais usadas)
  ├── Feed Social (posts, eventos, comunicados)
  ├── Quick Actions (ações rápidas)
  └── Widgets (KPIs, analytics)
  ↓
App Selecionada
  ↓
Dashboard (FRONT-005)
  ↓
Operação
```

---

## Componentes

### PortalHeader

```text
Logo do tenant (white label)
Nome do tenant
Seletor de contexto (tenant/unidade/local/perfil)
Busca global (atalho: Cmd+K / Ctrl+K)
Notificações (badge com contador)
Avatar do usuário
Menu de conta (perfil, configurações, logout)
```

### Sidebar

```text
Menu dinâmico baseado em App Registry
Agrupamento por módulo/categoria
Atalhos de apps favoritas
Indicador de contexto ativo (unidade/local)
Atualização automática por permissão
```

### Workspace

```text
Área principal de conteúdo
Widgets arrastáveis (opcional por plano)
Seções:
  - Bem-vindo / Resumo
  - Ações Rápidas
  - Apps Recentes
  - Favoritos
  - Feed Social
  - Analytics Pessoal
```

### AppLauncher

```text
Grid de apps autorizadas
Ícone + Nome + Descrição
Indicador de contexto necessário (⚠️)
Badge de novidade (nova funcionalidade)
Filtro por categoria/tag
Busca dentro do launcher
```

### GlobalSearch

```text
Pesquisa unificada (FRONT-004)
Atalho Cmd+K / Ctrl+K
Resultados agrupados por tipo:
  - Apps
  - Documentos
  - Pessoas
  - Chamados
  - Cursos
  - Posts
  - Ações diretas
Ação direta (abrir, criar, navegar)
```

### NotificationCenter

```text
Inbox unificado
Agrupamento por conversa/app
Marcação como lida
Favoritos
Arquivamento
Busca integrada
Ações diretas
```

### FeedSocial

```text
Posts institucionais
Comunicados de diretoria
Eventos corporativos
Aniversariantes
Reconhecimentos (badges, Kudos)
Comentários e curtidas
Compartilhamento
```

### QuickActions

```text
Ações frequentes do usuário
Ex:
  - "Abrir senha"
  - "Nova dispensação"
  - "Novo chamado"
  - "Fechar caixa"
  - "Gerar relatório"
Personalizável por perfil e app
```

### Widgets

```text
KPI Cards (indicadores pessoais)
Tiny charts (tendência semanal)
Alertas (SLA, pendências, vencimentos)
Links rápidos
```

---

## Regras

### Navegação

```text
Toda navegação de app passa pelo App Launcher ou Sidebar.
Nenhuma app é acessada por URL direta (sem contexto).
URLs diretas de apps operacionais redirecionam para Context Selection.
URLs diretas de Portal são permitidas (home, busca, notificações).
```

### Visibilidade

```text
Apps visíveis = Apps autorizadas para o contexto atual.
Troca de contexto → Sidebar e App Launcher são recarregados.
Apps sem contexto ativo não aparecem na lista (MD-042A).
```

### Estado

```text
Portal carrega em < 2s (P95).
Widgets carregam de forma assíncrona e não bloqueiam UI.
Falha em widget não quebra o Portal.
Notificações são atualizadas em tempo real (WebSocket/SSE).
```

### Responsividade

```text
Desktop: Sidebar + Workspace + widgets
Tablet: Sidebar colapsável + Workspace
Mobile: Bottom navigation + Workspace (PWA)
```

---

## Integrações

| MD | Finalidade |
|----|-----------|
| MD-020 — Portal Core Architecture | Estrutura do Portal |
| MD-042A — Portal Experience | Leis de experiência |
| MD-019 — App Registry Canônico | Catálogo de apps |
| MD-034 — Identity Access Management | Permissões, apps autorizadas |
| MD-088 — Global Notification Center | Notificações |
| MD-087 — Enterprise Search Platform | Busca global |
| MD-028 — Enterprise Social Network | Feed social |
| MD-029 — Digital Workplace | Feed, eventos, colaboração |
| MD-076 — Loyalty & Rewards | Badges, conquistas |
| MD-108 — Operational Context Engine | Contexto operacional |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-001 — Canonical Login Experience | Tela anterior |
| FRONT-002 — Context Selection Experience | Tela anterior |
| FRONT-004 — App Registry Navigation | Integração direta |
| FRONT-005 — Dashboard Framework | Próxima |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Shell do Portal, App Launcher, Busca, Notificações, Feed, Widgets |
| Backend | APIs de catálogo de apps, notificações, feed, busca |
| Dispatcher | Roteamento para SPs de portal, app registry, eventos |
| SP | Regras de apps autorizadas, contexto, permissões |
| Event Store | Registrar acesso ao Portal, troca de contexto, app aberta |

---

## Métricas

```text
Tempo de carregamento do Portal (P95)
Apps abertas por sessão
Buscas por sessão
Notificações lidas vs. recebidas
Engagement no Feed (posts lidos, curtidas)
Taxa de abandono no Portal
Erros de carregamento de widget
Satisfação com experiência do Portal (CSAT)
```

---

## Lei

```text
Portal é a porta única.
Portal é a Home.
Nenhuma app operacional abre sem passar pelo Portal.
A experiência do Portal é a experiência da plataforma.
```

---

## Próximo

```text
FRONT-003 completo
  ↓
FRONT-004 — App Registry Navigation
```
