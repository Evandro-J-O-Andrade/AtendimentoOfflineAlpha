# Plataforma Enterprise SaaS

> **Status:** README Enterprise Atual
>
> Fonte canônica oficial: `docs/canonical/`

Este documento substitui a visão antiga de produto HIS/CMDPro como descrição principal da plataforma.

O README histórico da fase inicial do projeto foi preservado em:

```text
legacy/docs/README.md
```

---

## Visão Atual da Plataforma

A Plataforma New Wave é uma:

```text
Plataforma Enterprise SaaS
B2B
B2C
Multi-Tenant
Multi-App
AI Native
Workflow Native
Analytics Native
Offline First
SP First
```

O HIS é apenas uma App do ecossistema.

Também são Apps da plataforma:

```text
Operacional

CRM

SAC

PDV

Financeiro

AVA

Social

BI

IA

Documentos

Workflow

Integrações

Marketplace
```

---

## Posicionamento Arquitetural

A arquitetura atual não é mais:

```text
CMDPro
Pronto Atendimento
UPA
Hospital
HIS como produto principal
```

A arquitetura atual é:

```text
Portal Enterprise Multi-Tenant

Portal Core

App Registry

AI Orchestration

Analytics

CRM

SAC

PDV

Financeiro

Operacional

AVA

Social

Documentos

Workflow

Integrações

Marketplace
```

---

## Princípios Canônicos Atuais

```text
Portal é a porta da plataforma.

App Registry define o que existe.

Dispatcher é a entrada oficial de ações.

SP-First mantém o negócio canônico.

Event Store mantém a história.

Security Center mantém a fronteira de segurança.

Analytics & Governance mantém a visão executiva.

Runtime mantém offline-first, sync e reconciliação.

IA e N8N são camadas nativas, não anexos externos.
```

---

## Arquitetura Canônica

```text
Portal Core
    ↓
Security Center
    ↓
Auth
    ↓
Context
    ↓
App Registry
    ↓
Dispatcher
    ↓
Action Registry
    ↓
Adapter Layer
    ↓
SP-First
    ↓
Event Store
    ↓
Analytics & Governance
```

Fluxo operacional:

```text
Usuário
    ↓
Sessão
    ↓
Tenant
    ↓
Contexto Operacional
    ↓
App
    ↓
Ação
    ↓
Dispatcher
    ↓
SP
    ↓
Evento
    ↓
Auditoria
    ↓
Analytics
```

---

## O Que Continua Válido do README Histórico

O README antigo já continha decisões que continuam canônicas:

```text
SP-First

Dispatcher

Event Store

Contexto Operacional

Offline First

Auditoria

Multi-Tenant conceitual

Portal Corporativo antes da Aplicação

App Registry implícito
```

Essas decisões não foram descartadas. Elas foram elevadas para a visão Enterprise.

---

## O Que Evoluiu

### Dispatcher

Continua:

```text
sp_master_dispatcher_runtime
```

Agora representa a porta oficial de entrada de ações da plataforma, não apenas de módulos assistenciais.

---

### Contexto Operacional

Continua:

```text
Tenant
Unidade
Local
Perfil
Sessão
```

Agora serve qualquer App do ecossistema, não apenas saúde.

---

### JWT

Continua, mas evolui para:

```text
JWT HttpOnly
Secure Cookie
SameSite=Strict
Refresh Token
Device Fingerprint
Zero Trust
```

JWT nunca deve ficar em `localStorage`, `sessionStorage` ou `IndexedDB`.

---

### Event Store

Continua, mas deixa de ser HIS.

Agora é:

```text
Portal Event Store
```

Fonte histórica de todas as ações, eventos, auditorias, analytics, runtime, IA, N8N, billing e segurança.

---

### Offline First

Continua.

Agora serve:

```text
CRM

PDV

Operacional

SAC

Financeiro

Documentos

Workflow
```

não apenas saúde.

---

## Segurança Enterprise

A segurança oficial está consolidada em:

```text
MD-027 — Security Center
```

Documento:

```text
docs/canonical/MD-027-Security-Center.md
```

A segurança cobre:

```text
JWT HttpOnly

Refresh Token

Device Fingerprint

Google Security

Webhook Signature

N8N Security

Tenant Isolation

Permission Engine

Session Governance

Audit Trail

Zero Trust
```

Lei de segurança:

```text
Nenhuma App implementa segurança própria.

Toda segurança pertence ao Security Center.
```

---

## Estrutura Enterprise Atual

```text
AtendimentoOfflineAlpha/

├── apps/
│   ├── portal/
│   ├── operacional/
│   ├── crm/
│   ├── sac/
│   ├── pdv/
│   ├── financeiro/
│   ├── ava/
│   ├── social/
│   ├── ia/
│   ├── admin/
│   └── marketplace/
│
├── dispositivos/
│   ├── painel/
│   ├── totem/
│   ├── kiosk/
│   ├── mobile/
│   └── tv/
│
├── packages/
│   ├── auth/
│   ├── context/
│   ├── events/
│   ├── workflow/
│   ├── audit/
│   ├── security/
│   ├── sdk/
│   └── ui/
│
├── backend/
│   ├── auth/
│   ├── portal/
│   ├── events/
│   ├── audit/
│   ├── integrations/
│   ├── n8n/
│   ├── ai/
│   └── gateway/
│
├── database/
│   ├── schema/
│   ├── procedures/
│   ├── migrations/
│   ├── views/
│   └── ledger/
│
├── dashboards/
├── workflow/
├── automacoes/
├── ia/
├── runtime/
├── integracoes/
├── infra/
├── tests/
├── assets/
├── docs/
└── legacy/
```

---

## Apps Canônicas

```text
Portal Core

Operacional

CRM

SAC

PDV

Financeiro

Estoque

Farmácia

BI

AVA

Social

Documentos

Chat

Ouvidoria

IA

N8N

Workflow

Integrações

Marketplace
```

Saúde, UPA, hospital, farmácia e pronto atendimento continuam válidos, mas como Apps dentro da plataforma.

---

## Camadas Canônicas

```text
Portal Core
    Auth
    Context
    Registry
    Dispatcher
    Event Store

Governance
    Analytics
    Security
    Runtime
    Billing
    AI

Apps
    Operacional
    CRM
    SAC
    PDV
    Financeiro
    Estoque
    Farmácia
    BI
    AVA
    Social
    Documentos
    Chat
    Ouvidoria

Infraestrutura
    Integration Hub
    Marketplace
    N8N
    AI Agents
    Webhooks
    APIs
```

---

## Analytics & Governance

Documento oficial:

```text
docs/canonical/MD-026-Portal-Analytics-Governance.md
```

Responsável por:

```text
KPIs globais

Uso da plataforma

Saúde do ecossistema

Custos

Apps

Tenants

Usuários

Receita

Disponibilidade

Performance

Segurança

Auditoria

Qualidade operacional
```

Lei:

```text
Nada relevante pode existir sem ser observado, medido, auditado e governado.
```

---

## Runtime

O Runtime continua sendo a camada de execução offline-first.

Responsabilidades:

```text
Sync

Heartbeat

Reconciliação

Workers

Fila

Single Writer

Idempotência

Cache

Snapshot

Locks
```

O Runtime serve todas as Apps, não apenas saúde.

---

## IA e N8N

IA e N8N são nativos do Portal Core.

IA não acessa banco diretamente.

N8N não acessa banco diretamente.

Ambos operam por APIs, eventos, permissões, tenant, auditoria e segurança.

---

## Billing e SaaS

A camada SaaS deve cobrir:

```text
Planos

Assinaturas

Licenças

Consumo

Marketplace

Faturamento SaaS

Custos IA

Custos API

Receita

MRR

ARR

Churn
```

---

## Integrações

A plataforma deve suportar conectores nativos para:

```text
WhatsApp

Email

SMS

Telegram

Google

Microsoft

Meta

OpenAI

Anthropic

N8N

Webhooks

REST

GraphQL
```

Integrações externas devem seguir Webhook Security.

---

## Marketplace

Futuro marketplace de:

```text
Apps de terceiros

Plugins

Temas

Widgets

Conectores
```

Toda extensão deve respeitar:

```text
Registry

Tenant Isolation

Security Center

Billing

Audit Trail
```

---

## Documentação Canônica

Índice oficial:

```text
docs/canonical/README_CANONICO.md
```

Freeze arquitetural:

```text
docs/canonical/FREEZE_ARQUITETURAL_2026.md
```

Plano diretor:

```text
docs/canonical/PLANO_DIRETOR_DA_DOCUMENTACAO_CANONICA.md
```

---

## Lei Final

```text
A Plataforma não é mais um HIS.

O HIS é uma App.

A Plataforma é um ecossistema Enterprise SaaS.

Toda App nasce do Portal.

Toda ação passa pelo Dispatcher.

Toda regra vive em SP.

Toda operação gera evento.

Toda segurança pertence ao Security Center.

Toda governança nasce do Analytics.

Tudo deve ser rastreável, auditável e multi-tenant.
```

---
