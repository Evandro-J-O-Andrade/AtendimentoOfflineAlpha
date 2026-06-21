# MD-033 — Analytics Governance

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir a camada de observabilidade, analytics, governança e tomada de decisão da Plataforma Enterprise Multi-Tenant.

---

## Princípio Fundamental

```text
Toda operação gera dados.

Todo dado gera métricas.

Toda métrica gera governança.

Nada relevante acontece fora da observabilidade.
```

---

## Lei Principal

```text
O Portal é a porta da plataforma.

O Analytics é a visão da plataforma.

A Governança é o controle da plataforma.
```

---

## Escopo

O Portal Analytics & Governance deve enxergar:

```text
Tenants
Apps
Usuários
Sessões
Permissões
Integrações
IA
N8N
Financeiro
CRM
SAC
PDV
Operacional
AVA
Social
Documentos
Marketplace
Runtime
Segurança
```

---

## Papel na Arquitetura

```text
Event Store
  ↓
Ledger / Audit Stream / Runtime Events
  ↓
Portal Analytics & Governance
  ↓
Executive Dashboard
Tenant Analytics
App Analytics
Governance Center
```

O Portal Analytics & Governance transforma dados operacionais em visão estratégica, controle de saúde, governança por tenant, governança por app e tomada de decisão baseada em evidência.

---

## Estrutura

## Executive Dashboard

Visão estratégica global.

KPIs:

```text
Tenants Ativos

Usuários Ativos

Sessões Ativas

Apps Instaladas

Apps Utilizadas

Receita

MRR

ARR

Churn

Consumo IA

Consumo APIs

Uso N8N

Storage

Processamento

Disponibilidade
```

---

## Tenant Analytics

Visão por Tenant.

KPIs:

```text
Usuários

Sessões

Apps habilitadas

Apps utilizadas

Consumo IA

Consumo APIs

Receita gerada

Tickets SAC

Treinamentos AVA

Engajamento Social
```

---

## App Analytics

Cada App registrada no Registry deve expor métricas.

Exemplos:

### CRM

```text
Leads

Conversões

Pipeline

Receita
```

### SAC

```text
Chamados

SLA

Tempo Resposta

NPS
```

### PDV

```text
Vendas

Ticket Médio

Produtos

Margem
```

### Operacional

```text
Atendimentos

Filas

Tempos

Produtividade
```

### AVA

```text
Cursos

Certificados

Conclusões
```

### Social

```text
Posts

Comentários

Engajamento

Comunidades
```

---

# Governance Center

Responsável por monitorar a saúde do ecossistema.

---

## Tenant Governance

Visualizar:

```text
Tenant

Plano

Status

Consumo

Limites

Integrações

Apps Ativas
```

---

## User Governance

Visualizar:

```text
Usuário

Perfis

Apps

Último acesso

Sessões

Permissões
```

---

## App Governance

Visualizar:

```text
App

Versão

Status

Uso

Incidentes

Dependências
```

---

## Security Governance

Integração direta com MD-026 e MD-034.

Monitorar:

```text
Logins

Falhas

Sessões

JWT

ACL

RBAC

ABAC

Webhooks

Auditoria
```

---

## Runtime Governance

Integração direta com MD-029.

Monitorar:

```text
Workers

Sync

Heartbeats

Reconciliações

Locks

Filas

Single Writer

Snapshots
```

---

## AI Governance

Integração direta com MD-027.

Monitorar:

```text
Agentes

Prompts

Modelos

Tokens

Custos

Workflows

RAG

Vetores

N8N
```

---

## Financial Governance

Integração direta com MD-030.

Monitorar:

```text
MRR

ARR

Receita

Custos

IA

APIs

Storage

Processamento

Licenças
```

---

## Event Driven Analytics

Toda métrica deve derivar de:

```text
Event Store

Ledger

Audit Stream

Runtime Events
```

Proibido:

```text
Contadores manuais

Métricas isoladas

Planilhas paralelas

KPIs sem origem rastreável
```

---

## Integração com App Registry

Toda App registrada deve informar:

```json
{
  "analytics": true,
  "governance": true,
  "dashboard": true
}
```

Além disso, toda App deve declarar:

```json
{
  "app": "CRM",
  "dominio": "CRM",
  "metricas_obrigatorias": [],
  "metricas_executivas": [],
  "metricas_operacionais": [],
  "eventos_fonte": [],
  "granularidade": "TENANT",
  "dashboard": true
}
```

---

## Multi-Tenant

Obrigatório:

```text
Isolamento por Tenant

Visão agregada para Super Admin

Visão restrita para Tenant Admin

Visão contextual para Usuários
```

Regras:

1. Super Admin pode visualizar a plataforma inteira.
2. Tenant Admin pode visualizar apenas o seu tenant.
3. Usuário comum pode visualizar apenas o contexto autorizado.
4. Nenhuma métrica pode vazar dados cross-tenant.
5. Dashboards globais devem preservar a origem por tenant.

---

## Regras

1. Toda métrica deve ter fonte rastreável.
2. Toda métrica deve respeitar tenant isolation.
3. Toda App registrada deve expor analytics quando `analytics = true`.
4. Todo dashboard deve derivar de Event Store, Ledger, Audit Stream ou Runtime Events.
5. Nenhuma métrica pode existir sem integração com MD-030.
6. Nenhuma métrica de segurança pode existir sem integração com MD-026 e MD-034.
7. Nenhuma métrica de IA pode existir sem integração com MD-027.
8. Nenhuma métrica de Social pode existir sem integração com MD-028.
9. Nenhuma métrica de Workplace pode existir sem integração com MD-029.
10. KPIs executivos devem ser auditáveis e reproduzíveis.
11. Alertas de governança devem gerar evento observável.
12. Métricas agregadas não podem apagar rastreabilidade.
13. Nenhuma App pode manter analytics isolado sem integração ao Portal.

---

## Modelo Canônico de KPI

```json
{
  "kpi_uuid": "UUID",
  "tenant_id": 0,
  "app": "CRM",
  "dominio": "CRM",
  "metrica": "CONVERSOES",
  "valor": 0,
  "unidade": "quantidade",
  "fonte": "EVENT_STORE",
  "granularidade": "TENANT",
  "periodo_inicio": "datetime",
  "periodo_fim": "datetime",
  "timestamp": "datetime"
}
```

---

## Modelo Canônico de App Analytics

```json
{
  "app": "SAC",
  "analytics": true,
  "governance": true,
  "dashboard": true,
  "metricas_operacionais": [
    "CHAMADOS",
    "SLA",
    "TEMPO_RESPOSTA",
    "NPS"
  ],
  "eventos_fonte": [
    "SAC_CHAMADO_ABERTO",
    "SAC_CHAMADO_ATRIBUIDO",
    "SAC_CHAMADO_RESOLVIDO"
  ]
}
```

---

## Integração Com Outros MDs

- **MD-005 (Event Store)**: fonte primária de eventos operacionais.
- **MD-010 (Security)**: base atual de segurança, sessão, RBAC e auditoria.
- **MD-011 (Analytics)**: dashboards e modelos analíticos.
- **MD-013 (Runtime Engine)**: heartbeat, sync, filas e workers.
- **MD-016 (Auditoria)**: rastreabilidade de mudanças.
- **MD-017 (MultiTenant)**: isolamento por tenant.
- **MD-019 / MD-023 (App Registry / Action Registry)**: apps e ações registradas.
- **MD-025 (Event Store Core)**: imutabilidade histórica.
- **MD-026 (Security Zero Trust)**: integração direta com Security Governance.
- **MD-027 (AI Orchestration Platform)**: integração direta com AI Governance.
- **MD-028 (Enterprise Social Network)**: integração direta com Social Analytics.
- **MD-029 (Digital Workplace Platform)**: integração direta com Workplace Metrics.
- **MD-030 (Enterprise Analytics & Governance Platform)**: visão única e governança de analytics.

---

## Proibições

São proibidos:

```text
Dashboard fora do Portal

KPIs sem Event Store

Analytics local por App sem integração

Governança isolada

Métricas não auditáveis

Contadores manuais

Métricas isoladas

Planilhas paralelas

KPIs sem origem rastreável

Leitura cross-tenant sem autorização

Métrica fora de Enterprise Analytics
```

---

## Lei Final

```text
Se o Portal é a porta da plataforma,

o Analytics é a visão,

e a Governança é o cérebro.

Nada relevante pode existir sem ser observado,
medido,
auditado
e governado.
```

---
