# MD-070 — Platform Operations Center

## Status

Documento Canônico do Centro Operacional da Plataforma Enterprise.

---

## Objetivo

Visão unificada de toda a plataforma.

Tudo em uma tela.

Decisões baseadas em dados operacionais.

---

## Princípio Fundamental

```text
Operação não é reativa.

Operação é proativa.
```

---

## Operations Center Architecture

```text
Operational Dashboard (unified)
    ├── Infrastructure
    ├── Applications
    ├── Security
    ├── Business
    ├── AI/N8N
    └── Finance/Billing
```

---

## Dashboards

### Infrastructure Dashboard

```text
CPU / RAM / Disk por serviço
Network traffic
Database connections
Redis hit rate
Queue depth
Container restarts
Deploy pipeline status
```

### Application Dashboard

```text
Request rate by app
Error rate by app
Latency by app
Active sessions
SLA compliance
SLO burn rate
Feature flags status
```

### Security Dashboard

```text
Failed logins per minute
Active threats
Token revocations
Permission denials
Security incidents
Compliance score
Pentest results
```

### AI/N8N Dashboard

```text
Tokens consumed (daily/weekly/monthly)
Cost per tenant per model
Model latency
Workflow executions
Workflow failures
Agent executions
AI accuracy metrics
```

### Business Dashboard

```text
Active tenants
New signups
Churn rate
MRR / ARR
NPS
Support tickets
Pipeline value
```

---

## Integration with Other MDs

- **MD-065 (Observability)**: logs, metrics, traces.
- **MD-066 (SRE)**: SLO, SLI, incident management.
- **MD-067 (Disaster Recovery)**: DR status.
- **MD-068 (Backup)**: backup status.
- **MD-069 (Global Deployment)**: multi-region status.

---

## Regras Canônicas

1. Operations Center é a única fonte de verdade operacional.
2. Todos os dashboards são em tempo real (ou near-real-time).
3. P0 incidents aparecem em todos os dashboards relevantes.
4. Operations Center é acessível 24x7.
5. Runbooks estão linkados nos dashboards.
6. Cost visibility é obrigatória.
7. Security é dashboard separado mas integrado.
8. Business metrics são first-class.
9. AI/N8N visibility é mandatória.
10. Operations Center é o cockpit da plataforma.