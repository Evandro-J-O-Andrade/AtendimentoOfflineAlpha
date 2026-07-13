# MAP-005 — Portal Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura oficial do Portal Enterprise.

---

## Classificação
```text
Tipo: Foundation Architecture
Camada: Platform Core
Prioridade: Crítica
Obrigatoriedade: Global
```

---

## Objetivo
Definir a arquitetura oficial do Portal Enterprise da Plataforma Midas.

---

## Lei Canônica MAP-005-001
```text
Portal é o Entry Point oficial da plataforma.
```

---

## Lei Canônica MAP-005-002
```text
Nenhum usuário acessa um domínio diretamente.
```

---

## Lei Canônica MAP-005-003
```text
Portal não executa operações de negócio.
```

---

## Lei Canônica MAP-005-004
```text
Portal orquestra experiências.
```

---

## Lei Canônica MAP-005-005
```text
Portal é Runtime, não apenas interface (LEI 23).
Portal expõe a mesma capacidade para interfaces humanas
e para interfaces computacionais, via o mesmo Runtime.
```

---

## Leis Canônicas Globais Aplicáveis

### LC-002 — Identity ≠ Operational Context
```text
Login responde: Quem é você?
Contexto responde: Onde você está operando?
```

### LC-009 — IA é Transversal
```text
AI Core atravessa toda plataforma.
Portal AI: Assistente Corporativo
HIS AI: Assistente Clínico
CRM AI: Assistente Comercial
RH AI: Assistente de Pessoas
Finance AI: Assistente Financeiro
Analytics AI: Assistente Executivo
Workflow AI: Assistente de Processos
```

### LC-014 — Portal = Hub Corporativo
```text
Portal é o Digital Workplace Enterprise.
Portal não é dashboard.
Portal não é intranet.
Portal é o orquestrador da experiência.
```

### LC-015 — Intranet é Aplicação
```text
Intranet = Aplicação
Chat = Aplicação
AVA = Aplicação
HIS = Aplicação
CRM = Aplicação
RH = Aplicação
Financeiro = Aplicação
```

### LC-016 — AI Command Center
```text
Governando:
Prompts, Agentes, Custos, Tokens, Modelos, Execuções, Treinamentos, Knowledge Base
```

### LC-008 — Audit First
```text
Toda ação crítica gera evento.
Login, Logout, MFA, Troca de senha, Revogação, Contexto alterado.
```

---

## Posicionamento Arquitetural
```text
IAM
 ↓
Portal
 ↓
Application Registry
 ↓
Domínios
```

---

## Papel do Portal
```text
Digital Workplace
Enterprise Hub
Command Center
Unified Experience Layer
```

---

## Estrutura Principal
```text
Portal
│
├── Home
├── Widgets
├── Search
├── Notifications
├── Favorites
├── Timeline
├── AI Workspace
├── Quick Actions
├── App Registry
└── User Workspace
```

---

## Home Architecture

### Composição
```text
Widgets
Favoritos
Alertas
Pendências
Atividades
KPIs
```

### Lei
```text
Todo usuário possui sua própria Home.
```

---

## Widget Architecture

### Tipos
```text
KPI
Chart
List
Feed
Alert
Shortcut
Timeline
```

### Lei
```text
Widgets são plugáveis.
```

---

## Search Architecture

### Pesquisa
```text
Documentos
Pacientes
Clientes
Chamados
Treinamentos
Contratos
Mensagens
Eventos
```

### Base
```text
Search Engine + AI + Permission Engine
```

### Lei
```text
Resultados respeitam permissões.
```

---

## Notification Center

### Tipos
```text
Informativo
Alerta
Crítico
Urgente
```

### Smart Notification Engine
```text
Eventos
Regras
IA
Monitoramento
```

---

## Universal Timeline

### Origens
```text
Workflow
HIS
CRM
RH
Financeiro
Documentos
```

### Lei
```text
Timeline é leitura. Nunca execução.
```

---

## Predictive Workspace

IA analisa:
```text
Perfil
Histórico
Pendências
Agenda
Contexto
```

Sugere:
```text
O que fazer
O que revisar
O que aprovar
O que acompanhar
```

---

## Portal como Runtime (LEI 23)

### Consumidores Universais
O Portal não serve apenas ao frontend React. Toda capacidade
deve ser consumível pelas mesmas interfaces:

```text
Interfaces humanas (UI):
  Web (React)
  Mobile
  Kiosk
  TV Display

Interfaces computacionais (API):
  APIs externas
  MCPs (Model Context Protocol)
  Agentes de IA
  Automações
  Integrações futuras
```

### Fluxo Único (Humano ou Computacional)
Nenhum consumidor cria lógica paralela. Todos usam o mesmo Runtime.

```text
Interface (humana ou computacional)
        ↓
MCP / API
        ↓
Portal Runtime
        ↓
Master
        ↓
Dispatcher
        ↓
Executors
        ↓
Stored Procedures
        ↓
Banco Canônico
```

### MVPs do Portal
Cada domínio nasce com MVP mínimo. Para o Portal:

```text
MVP-001 — Dashboard inicial
MVP-002 — Widgets
MVP-003 — Favoritos
MVP-004 — Layouts
MVP-005 — Notificações
```

Cada MVP exige:

```text
MD (Materialização)
BR (Business Rules)
MAP (Mapeamento)
Contratos
APIs
Procedures
Testes
Critérios de aceite
```

### APIs Canônicas do Portal
```text
Portal API
Runtime API
Auth API
Context API
Dashboard API
Widget API
Notification API
AI API
MCP API
```

### Proibição (LEI 23)
```text
É proibido criar lógica exclusiva para IA que contorne
o Kernel, os contratos ou as Stored Procedures canônicas.
Nenhuma IA acessa o banco diretamente.
```

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-004 — Portal Context | Contexto |
| MAP-006 — App Registry | Apps |
| MD-006 — Digital Workplace | Workplace |
| FRONT-003 — Portal Experience | UX |
| FRONT-030 — Home Personalization | Personalização |