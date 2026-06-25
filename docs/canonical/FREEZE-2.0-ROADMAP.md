# Freeze Arquitetural 2.0 - Roadmap

## Status Atual

```text
MD-001 → MD-100: CONGELADOS (Fundação)
MD-123 → MD-142: EM ANDAMENTO (Refinamento)
```

---

## Blocos do Freeze 2.0

### BLOCO 1 — Portal & Contexto (✅ CONCLUÍDO)
```text
MD-123 Portal Canonical Experience
MD-124 Context First Architecture
```

**Congela:**
- Portal é Sistema Operacional Corporativo
- Contexto é fronteira operacional
- Login → Portal → Contexto → Dashboard → Apps

### BLOCO 2 — Displays & Painéis (✅ CONCLUÍDO)
```text
MD-125 Enterprise Display Architecture
MD-126 Display Authentication Architecture
MD-127 Display Management Domain
MD-128 Display Profiles and Categories
MD-129 Public Communication Panels
MD-130 Clinical Panels Architecture
MD-131 Management Panels Architecture
```

**Congela:**
- Display é cidadão de primeira classe
- Displays autenticam no Portal de Displays
- Categorias de painéis (Clinical, Management, Public, Operational)

### BLOCO 3 — Comunicação Operacional (✅ CONCLUÍDO)
```text
MD-132 Operational Communication Center
MD-133 Speech and TTS Architecture
MD-134 Display Event Distribution Engine
```

**Congela:**
- OCC distribui chamadas/alertas
- TTS Google → System fallback
- Eventos garantidos via WebSocket

### BLOCO 4 — Analytics (✅ CONCLUÍDO)
```text
MD-135 Enterprise Analytics Architecture
```

**Congela:**
- Analytics é aplicação separada
- Fonte: Event Store

### BLOCO 5 — Eventos & Auditoria (✅ CONCLUÍDO)
```text
MD-136 Event Driven Enterprise
MD-137 Clinical Audit Architecture
MD-138 Immutable Clinical Records
MD-139 Clinical Retification and Revocation Model
```

**Congela:**
- Tudo gera evento
- Nada é deletado (cancelado/retificado)
- Schema padrão de eventos

### BLOCO 6 — Domínio Saúde (✅ CONCLUÍDO)
```text
MD-140 Healthcare Operational Flow
MD-141 Healthcare Execution Domains
```

**Congela:**
- Senha → GPAT → FFA → Atendimento
- Domínios diagnósticos/terapêuticos

### BLOCO 7 — Consolidação (✅ CONCLUÍDO)
```text
MD-142 Unified Enterprise Operating System
```

**Congela:**
- 3 camadas: Plataforma, Capacidades, Domínios

---

## Próximos Passos (AGUARDANDO CONGELAMENTO)

```text
FRONT-001 Login Experience
FRONT-002 Context Selection
FRONT-003 Portal Experience
FRONT-004 App Registry Navigation
FRONT-005 Dashboard Framework
FRONT-006 Display Management
FRONT-007 Clinical Panels UI
FRONT-008 Analytics Views
FRONT-009 TTS Integration
FRONT-010 Notification Center
```

---

## BRs (Business Rules) Existentes

```text
BR-001 Auth & Session Rules ✅
BR-002 Password Flow Rules ✅
BR-003 HIS Clinical Rules ✅
BR-004 CRM Rules ✅
BR-005 RH Rules ✅
```

Próximos BRs críticos faltando:
```text
BR-006 Pharmacy Execution
BR-007 Diagnostic & Exam Flow
BR-008 Scheduling & Agenda
BR-009 Care Continuity
BR-010 Inventory & Supply
```

---

## Sequência de Implementação

```text
MAPs (congelados) → BRs (em andamento) → SPs → APIs → React
```

---

## MAPs (Arquitetura de Domínios) - Status Final

```text
MAP-001 Enterprise Domain Architecture ✅
MAP-002 Tenant/Identity Architecture ✅
MAP-003 Pharmacy & Clinical Execution ✅
MAP-004 Diagnostic & Exams ✅
MAP-005 Scheduling & Agenda ✅
MAP-006 Care Continuity/Patient Journey ✅
MAP-007 Inventory & Supply Chain ✅
MAP-008 Workforce & HR Operational ✅
MAP-009 Operational Command ✅
MAP-010 Billing & Revenue Cycle ✅
MAP-011 Admin & Governance ✅
MAP-012 Security & Identity Deep ✅
MAP-013 BI & Analytics ✅
MAP-014 Integration & External Ecosystem ✅
```

Total: 14 MAPs completos.

---

## Regras do Freeze 2.0

```text
✅ Documentar apenas o que já foi decidido
❌ Não criar novos domínios
❌ Não aumentar escopo
❌ Não inventar funcionalidades
❌ Não modelar código, React, APIs
```