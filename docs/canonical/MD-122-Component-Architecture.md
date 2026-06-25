# MD-122 — Component Architecture & Reusability

## Status
Documento Canônico da Plataforma.
Definição de componentes reutilizáveis e padrões de experiência.

## Classificação
```text
Tipo: Foundation Architecture
Camada: Platform Core
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
Definir padrão de reutilização de componentes sem sacrificar identidade de domínio.

---

## Lei Canônica MD-122-001
```text
Componentes são reutilizáveis.
Experiência é contextual.
```

---

## Camada 1 — Core UI Components

Componentes universais:

```text
Button
Input
Select
DatePicker
Modal
Drawer
Tabs
Card
Table
Badge
Avatar
Tooltip
Accordion
Pagination
```

---

## Camada 2 — Enterprise Components

Reutilização de negócio:

```text
ContextSelector
SidebarFramework
HeaderFramework
DashboardWidget
NotificationCenter
Timeline
AuditTrail
SpeechService
ThemeProvider
FormBuilder
DataTable
ChartWrapper
```

---

## Camada 3 — Healthcare Components

Reutilização do HIS:

```text
FilaPaciente
SenhaDisplay
PacienteCard
ClassificacaoRisco
TimelineAtendimento
PainelChamadas
PrioridadeBadge
StatusChip
ClockTimer
```

---

## Speech Service Arquitetura

Serviço transversal:

```text
SpeechService
├── TTS Providers
│   ├── Google TTS
│   ├── System TTS
│   ├── Azure TTS
│   └── AWS Polly
├── Voice Profiles
├── Language Support
├── Cache Audio
└── Fallback Chain
```

---

## Theme Engine

Identidade visual por domínio:

```text
Theme Engine
├── Core Tokens
│   ├── primary
│   ├── secondary
│   ├── success
│   ├── warning
│   ├── danger
│   └── background
├── Domain Profiles
│   ├── Operacional
│   ├── Farmacia
│   ├── CRM
│   ├── RH
│   └── Financeiro
└── Dynamic Branding
```

---

## Sidebar Framework

Contexto-driven:

```text
Portal Sidebar
├── Início
├── Aplicações
├── Favoritos
└── Notificações

App Sidebar
├── Menu do Domínio
├── Workflows
├── Relatórios
└── Configurações
```

---

## Header Framework

Adaptável:

```text
Header Base
├── Context Info
├── Quick Actions
├── Notifications
└── User Menu
```

---

## Dashboard Framework

Widget-based:

```text
Dashboard
├── KPI Cards
├── Charts
├── Lists
├── Timelines
└── Custom Widgets
```

---

## Workflow Engine

Reutilização de mecanismo:

```text
Estrutura única:
Workflow Steps
Transitions
Events
Actions
Validators
```

Consumido por:

```text
Atendimento
Farmácia
Faturamento
RH
CRM
```

---

## Reutilização Proibida

```text
❌ Copiar telas completas
❌ Duplicar regras de negócio
❌ Hardcoded estilos
❌ Componentes sem prop drilling
❌ Lógica de domínio em UI
```

---

## Portal Layout Framework

### Windows-8 Style Containers
```text
Portal Layout
├── Tile Grid (Live Tiles)
├── Domain Tiles
├── App Tiles
├── Dashboard Tiles
├── Display Tiles
└── Config Tiles
```

---

### Domain Containers
Cada domínio como container visual:

```text
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Assistencial    │    │ Estoque         │    │ Displays        │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Farmácia        │    │ Faturamento     │    │ Analytics       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

### Live Tile Features
Container mostra dados dinâmicos:

```text id="f9j4l1"
Fila Assistencial:
18 aguardando
5 prioritários
```

```text id="b2m7n3"
Farmácia:
4 dispensações
2 críticas
```

```text id="p5q8r2"
Displays:
12 online
1 offline
```

---

## Display Management UI

### Display Containers
No Portal para gestores:

```text id="d7s1t4"
Displays
├── TVs
├── Totems
├── Kiosks
├── VideoWalls
└── Monitors
```

---

### Live Display Status
Ao clicar em Displays:

```text id="v3w6x5"
TV Recepção Principal
ONLINE - Última atualização: agora

Painel Pediatria
ONLINE - Exibindo: Senhas

Totem Laboratório
OFFLINE - Offline há 15 min

Monitor Clínico
ONLINE - Exibindo: Paciente 123
```

---

### Display Actions
```text id="y9z2a1"
Trocar Playlist
Enviar Mensagem
Reiniciar Display
Ver Logs
```

---

## Domain Experience Separation

### Portal vs App
Portal é launcher. App é operação.

```text Portal Experience
┌─────────────────┐
│ HIS             │
└─────────────────┘
┌─────────────────┐
│ Farmácia        │
└─────────────────┘
┌─────────────────┐
│ Displays        │
└─────────────────┘
```

```text App Experience (HIS)
Sidebar
├── Recepção
├── Triagem
├── Consultórios
├── Observação
└── Painéis
```

---

## Enterprise Architecture Layers

### Camada 1 — Plataforma
Infraestrutura:

```text
IAM
Portal
Contexto
App Registry
Eventos
Auditoria
Displays
Analytics
Comunicação Operacional
Workflow
Notificações
```

---

### Camada 2 — Capacidades Compartilhadas
Serviços reutilizáveis:

```text
Fila
Agenda
Documentos
Mensageria
TTS
Uploads
Dashboards
Relatórios
Alertas
Workflows
```

---

### Camada 3 — Domínios
Domínios de negócio:

```text
HIS
Farmácia
Financeiro
CRM
RH
Estoque
Laboratório
RX
ECG
Internação
Convênios
Remoção
```

---

## Enterprise Operating System

### Arquitetura Consolidada

```text
CAMADA 1 — PLATAFORMA
Portal (entry point único)
Contexto (fronteira operacional)
Pessoa (identidade raiz)
Eventos (fonte da história)
Auditoria (rastreabilidade total)
Displays (cidadão de primeira classe)
Analytics (aplicação separada)

CAMADA 2 — CAPACIDADES COMPARTILHADAS
Fila
Agenda
Documentos
Mensageria
TTS
Uploads
Dashboards
Relatórios
Alertas
Workflows

CAMADA 3 — DOMÍNIOS
HIS (fluxo: Senha → GPAT → FFA → Atendimento)
Farmácia (Receita → Dispensação)
Financeiro (Fatura → Pagamento)
CRM (Contato → Agendamento)
RH (Funcionário → Folha)
Estoque (Produto → Movimento)
Laboratório (Exame → Resultado)
RX (Estudo → Laudo)
Internação (Leito → Alta)
Remoção (Solicitada → Concluída)
```

---

## Architecture Decision Record

### ADR-001: Portal como OS Corporativo
Portal não é tela inicial. Portal é sistema operacional.

### ADR-002: Identidade como Pessoa
Usuário morre. Pessoa sobrevive. Multi-contexto único.

### ADR-003: Display como Canal Oficial
Tudo sai pelo display. TTS fallback. Offline-first.

### ADR-004: Eventos Imutáveis
Nada é deletado. Sempre retificado/cancelado.

### ADR-005: 3 Camadas Claras
Plataforma, Capacidades, Domínios. Nada cruza camadas sem evento.

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MD-110 | Leis canônicas |
| MAP-005 | Portal Architecture |
| FRONT-003 | Portal Experience |