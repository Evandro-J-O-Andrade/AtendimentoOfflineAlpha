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

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-004 — Portal Context | Contexto |
| MAP-006 — App Registry | Apps |
| MD-006 — Digital Workplace | Workplace |
| FRONT-003 — Portal Experience | UX |
| FRONT-030 — Home Personalization | Personalização |